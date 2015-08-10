class Survey < ActiveRecord::Base
  # Constants
  SURVEY_DATA_LOCATION = ['lib', 'data', 'surveys']
  SURVEY_LIST = ['about-me', 'additional-information-about-me', 'about-my-family', 'my-interest-in-research', 'my-sleep-pattern', 'my-sleep-quality', 'my-quality-of-life', 'my-health-conditions', 'my-sleep-apnea', 'my-sleep-apnea-treatment', 'my-risk-profile']
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

  def self.load_from_file(name)
    ## CREATES A NEW SURVEY

    data_file = YAML.load_file(Rails.root.join(*(SURVEY_DATA_LOCATION + ["#{name}.yml"])))

    # Find or Create Survey
    survey = Survey.where(slug: data_file["slug"]).first_or_create
    survey.update(name_en: data_file["name"], description_en: data_file["description"], status: data_file["status"], first_question_id: nil, default_position: data_file["default_position"])

    data_file["questions"].each do |question_attributes|
      question = Question.where(slug: question_attributes["slug"]).first_or_create
      question.update(text_en: question_attributes["text"], display_type: question_attributes["display_type"])

      question_attributes["answer_templates"].each do |answer_template_attributes|
        answer_template = AnswerTemplate.where(name: answer_template_attributes["name"]).first_or_create
        answer_template.update(data_type: answer_template_attributes["data_type"], text: answer_template_attributes["text"], display_type_id: answer_template_attributes["display_type_id"], allow_multiple: answer_template_attributes["allow_multiple"].present?, target_answer_option: answer_template_attributes["target_answer_option"], preprocess: answer_template_attributes["preprocess"], unit: answer_template_attributes["unit"])
        (question.answer_templates << answer_template) unless question.answer_templates.exists?(answer_template.id)

        if answer_template_attributes.has_key?("answer_options")
          answer_template_attributes["answer_options"].each do |answer_option_attributes|
            answer_option = answer_template.answer_options.find_or_create_by(slug: answer_option_attributes["slug"])
            answer_option.update(value: answer_option_attributes["value"], text: answer_option_attributes["text"], hotkey: answer_option_attributes["hotkey"], display_class: answer_option_attributes["display_class"])
          end
        end
      end

      survey.first_question_id = question.id if survey.first_question_id.blank?
    end

    survey.save
  end

  def write_to_file
    file_hash = {}

    file_hash["name"] = name
    file_hash["slug"] = slug
    file_hash["default_position"] = default_position
    file_hash["description"] = description
    file_hash["status"] = status

    file_hash["questions"] = questions.map do |q|
      q_hash = {}
      q_hash["text"] = q.text
      q_hash["slug"] = q.slug
      q_hash["display_type"] = q.display_type
      q_hash["answer_templates"] = q.answer_templates.map do |at|
        at_hash = {}
        at_hash["name"] = at.name
        at_hash["data_type"] = at.data_type
        at_hash["text"] = at.text if at.text.present?
        at_hash["unit"] = at.unit if at.unit.present?
        at_hash["preprocess"] = at.preprocess if at.preprocess.present?
        at_hash["allow_multiple"] = at.allow_multiple if at.allow_multiple
        at_hash["target_answer_option"] = at.target_answer_option if at.target_answer_option.present?
        if at.answer_options.present?
          at_hash["answer_options"] = at.answer_options.map do |ao|
            ao_hash = {}
            ao_hash["slug"] = "#{at.name}_#{ao.value}".dasherize
            ao_hash["text"] = ao.text
            ao_hash["hotkey"] = ao.hotkey if ao.hotkey.present?
            ao_hash["value"] = ao.value
            ao_hash["display_class"] = ao.display_class if ao.display_class.present?
            ao_hash
          end
        end
        at_hash
      end
      q_hash
    end

    File.open(File.join(Rails.root, "/lib/data/myapnea/surveys/generated/#{slug}.yml"), 'w') {|f| f.write file_hash.to_yaml }
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
