class Survey < ActiveRecord::Base
  # Constants
  STATUS = ['show', 'hide']

  # Concerns
  include Localizable
  include Deletable

  # Callbacks
  after_create :create_default_encounters

  # Translations
  localize :name
  localize :description
  localize :short_description

  # Model Validation
  validates_presence_of :name_en, :slug, :status, :user_id
  validates_uniqueness_of :slug, scope: [ :deleted ]
  validates_format_of :slug, with: /\A(?!\Anew\Z)[a-z][a-z0-9\-]*\Z/
  validates_numericality_of :child_min_age, greater_than_or_equal_to: 0, less_than_or_equal_to: 8, if: :pediatric?
  validates_numericality_of :child_max_age, greater_than_or_equal_to: 0, less_than_or_equal_to: 8, if: :pediatric?

  # Model Relationships
  belongs_to :user
  has_many :answer_sessions, -> { where deleted: false }
  has_many :survey_question_orders, -> { order :question_number }
  has_many :questions, through: :survey_question_orders
  has_many :survey_encounters
  has_many :encounters, -> { where deleted: false }, through: :survey_encounters
  has_many :survey_user_types, -> { where deleted: false }

  # Named scopes
  scope :viewable, -> { where(status: 'show').where.not(slug: nil) }
  scope :pediatric, -> { where pediatric: true }
  scope :non_pediatric, -> { where pediatric: false }

  # Survey Methods

  def to_param
    slug.blank? ? id : slug
  end

  def self.find_by_param(input)
    self.where("surveys.slug = ? or surveys.id = ?", input.to_s, input.to_i).first
  end

  # Simplified Version
  # def to_param
  #   slug
  # end

  # def self.find_by_param(input)
  #   find_by_slug(input)
  # end

  def editable_by?(current_user)
    self.user_id == current_user.id
  end

  def atomic_first_or_create_answer_session(user, encounter_slug, child_id: nil)
    begin
      self.answer_sessions.where(user_id: user.id, encounter: encounter_slug, child_id: child_id).first_or_create!
    rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid
      retry
    end
  end

  def launch_single(user, encounter_slug)
    self.atomic_first_or_create_answer_session(user, encounter_slug)
  end

  def launch_single_for_children(user, encounter_slug)
    user.children.each do |child|
      self.atomic_first_or_create_answer_session(user, encounter_slug, child_id: child.id)
    end
  end

  def launch_encounter_for_user(user, survey_encounter)
    if self.enough_time_has_past?(user, survey_encounter) and self.no_dependency_or_parent_encounter_locked?(user, survey_encounter)
      self.launch_single(user, survey_encounter.encounter.slug)
      true
    else
      false
    end
  end

  def enough_time_has_past?(user, survey_encounter)
    if oldest_locked_time = self.dependent_locked_answer_sessions(user, survey_encounter).pluck(:locked_at).min
      oldest_locked_time.to_date <= (Date.today - survey_encounter.encounter.launch_days_after_sign_up.days)
    else
      user.created_at.to_date <= (Date.today - survey_encounter.encounter.launch_days_after_sign_up.days)
    end
  end

  def no_dependency_or_parent_encounter_locked?(user, survey_encounter)
    if survey_encounter.parent_survey_encounter
      user.answer_sessions.where(survey_id: survey_encounter.parent_survey_encounter.survey.id, encounter: survey_encounter.parent_survey_encounter.encounter.slug, locked: true, child_id: nil).count > 0
    else
      true
    end
  end

  def dependent_locked_answer_sessions(user, survey_encounter)
    if survey_encounter.parent_survey_encounter
      user.answer_sessions.where(survey_id: survey_encounter.parent_survey_encounter.survey.id, encounter: survey_encounter.parent_survey_encounter.encounter.slug, locked: true, child_id: nil).where.not(locked_at: nil)
    else
      user.answer_sessions.none
    end
  end

  def self.launch_followup_encounters
    surveys_launched = 0
    survey_changes = {}
    assigned_survey_user_ids = []

    Survey.current.viewable.non_pediatric.each do |survey|
      survey.survey_encounters.each do |survey_encounter|
        user_types = survey.survey_user_types.pluck(:user_type)
        # Select User Types
        user_scope = User.current.where(user_types.collect{|x| "users.#{x.to_sym} = 't'"}.join(' or '))
        # Select Users created `launch_days_after_sign_up` days before today
        user_scope = user_scope.where("DATE(users.created_at) <= ?", Date.today - survey_encounter.encounter.launch_days_after_sign_up.days)
        # Select Users who have not yet been assigned the survey
        users = user_scope.where.not(id: AnswerSession.current.where(survey_id: survey.id, encounter: survey_encounter.encounter.slug).select(:user_id))
        answer_sessions_count = AnswerSession.count

        users.each do |user|
          assigned_survey_user_ids << user.id if survey.launch_encounter_for_user(user, survey_encounter)
        end


        answer_sessions_change = AnswerSession.count - answer_sessions_count
        if answer_sessions_change > 0
          survey_changes[survey.slug] ||= { name: survey.name }
          survey_changes[survey.slug][:encounters] ||= []
          survey_changes[survey.slug][:encounters] << { name: survey_encounter.encounter.name, answer_sessions_change: answer_sessions_change }
          surveys_launched += answer_sessions_change
        end
      end
    end

    users_assigned_new_surveys = User.current.where(id: assigned_survey_user_ids)
    users_emailed = users_assigned_new_surveys.where(emails_enabled: true)

    if surveys_launched > 0
      User.where(owner: true, emails_enabled: true).each do |owner|
        UserMailer.encounter_digest(owner, surveys_launched, surveys_changes).deliver_later if Rails.env.production?
      end
    end
    users_emailed.each do |user|
      UserMailer.new_surveys_available(user).deliver_later if Rails.env.production?
    end
    true
  end

  def has_custom_report?
    File.exists?(Rails.root.join("app", "views", "surveys", "reports", "_#{self.slug.underscore}.html.haml"))
  end

  private

    def create_default_encounters
      baseline = Encounter.current.find_by_slug 'baseline'
      self.survey_encounters.create(encounter_id: baseline.id, user_id: self.user_id) if baseline
    end

end
