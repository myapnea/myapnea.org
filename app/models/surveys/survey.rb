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

  private

    def create_default_encounters
      self.encounters.create(name: 'Baseline', slug: 'baseline', user_id: self.user_id) if self.encounters.count == 0
    end

end
