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
  has_many :encounters, -> { where deleted: false }
  has_many :survey_user_types, -> { where deleted: false }
  has_many :survey_answer_frequencies
  has_many :reports

  # Named scopes
  scope :viewable, -> { where(status: 'show').where.not(slug: nil) }
  scope :pediatric, -> { where pediatric: true }
  scope :non_pediatric, -> { where pediatric: false }

  # Class Methods

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

  # Instance Methods
  def launch_single(user, encounter, position: self[:default_position], send_email: false)
    answer_session = user.answer_sessions.find_or_initialize_by(encounter: encounter, survey_id: self.id, child_id: nil)
    answer_session.position = position
    if answer_session.new_record?
      return_object = nil
      newly_created = true
    else
      return_object = user
      newly_created = false
    end
    answer_session.save!

    if newly_created and send_email
      Rails.logger.info "Sending followup survey email to #{user.email}"
      UserMailer.followup_survey(answer_session).deliver_later if Rails.env.production?
    end

    return_object
  end

  def launch_multiple(users, encounter, options = {})
    already_assigned = []

    users.each do |user|
      already_assigned << launch_single(user, encounter, options)
    end

    already_assigned.compact!

    already_assigned
  end

  def launch_single_for_children(user, encounter, position: self[:default_position], send_email: false)
    user.children.each do |child|
      answer_session = user.answer_sessions.find_or_initialize_by(encounter: encounter, survey_id: self.id, child_id: child.id)
      answer_session.position = position
      answer_session.save
    end
  end

  def question_text(question_slug)
    q = questions.where(slug: question_slug).first

    q.present? ? q.text : nil
  end

  def self.launch_followup_encounters
    surveys_launched = 0
    survey_changes = {}

    Survey.current.viewable.non_pediatric.where.not(publish_date: nil).each do |survey|
      survey.encounters.each do |encounter|
        Rails.logger.debug "Followup Survey: #{survey.slug} #{encounter.slug}"
        user_types = survey.survey_user_types.pluck(:user_type)
        Rails.logger.debug "Survey User Types: #{user_types}"
        # Select User Types
        user_scope = User.current.where(user_types.collect{|x| "users.#{x.to_sym} = 't'"}.join(' or '))
        # Select Users created `launch_days_after_sign_up` days before today
        user_scope = user_scope.where("(DATE(users.created_at) > ? and DATE(users.created_at) <= ?) or (DATE(users.created_at) <= ? and ? <= ?)", survey.publish_date.to_date, Date.today - encounter.launch_days_after_sign_up.days, survey.publish_date.to_date, survey.publish_date.to_date, Date.today - encounter.launch_days_after_sign_up.days)
        # Select Users who have not yet been assigned the survey
        users = user_scope.where.not(id: AnswerSession.current.where(survey_id: survey.id, encounter: encounter.slug).select(:user_id))
        Rails.logger.debug "Users: #{users.count}"
        answer_sessions_count = AnswerSession.count
        survey.launch_multiple(users, encounter.slug, send_email: true)
        answer_sessions_change = AnswerSession.count - answer_sessions_count
        if answer_sessions_change > 0
          survey_changes[survey.slug] ||= { name: survey.name }
          survey_changes[survey.slug][:encounters] ||= []
          survey_changes[survey.slug][:encounters] << { name: encounter.name, answer_sessions_change: answer_sessions_change }
          surveys_launched += answer_sessions_change
        end
      end
    end

    Rails.logger.debug "Surveys Launched: #{surveys_launched}"
    Rails.logger.debug survey_changes

    if surveys_launched > 0
      User.where(owner: true, emails_enabled: true).each do |owner|
        UserMailer.encounter_digest(owner, surveys_launched, surveys_changes).deliver_later if Rails.env.production?
      end
    end
  end

  private

    def create_default_encounters
      self.encounters.create(name: 'Baseline', slug: 'baseline', user_id: self.user_id) if self.encounters.count == 0
    end

end
