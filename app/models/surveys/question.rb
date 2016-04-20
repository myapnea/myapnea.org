class Question < ActiveRecord::Base
  # Default Scope
  # Constants
  DISPLAY_TYPES = ["custom_date_input", "radio_input", "checkbox_input", "height_input", "number_input", "radio_input_multiple"]

  # Attribute related macros
  # Associations
  belongs_to :user
  has_many :answer_templates_questions, -> { order(:position, :created_at) }
  has_many :answer_templates, through: :answer_templates_questions
  # has_and_belongs_to_many :answer_templates, -> { current.order("answer_templates.created_at asc") }
  belongs_to :group
  has_many :answers
  belongs_to :question_help_message
  has_many :survey_answer_frequencies
  has_many :votes

  # Validations
  validates :text_en, presence: true
  validates :slug, presence: true, uniqueness: { scope: [:deleted] }, format: /\A(?!\Anew\Z)[a-z][a-z0-9\-]*\Z/
  validates :user_id, presence: true
  # validates_uniqueness_of :slug, scope: [ :deleted ]
  # validates_format_of :slug, with: /\A(?!\Anew\Z)[a-z][a-z0-9\-]*\Z/

  # Callback
  # Other macros
  # Concerns
  include Localizable
  include Votable
  include Deletable

  # Named scopes
  scope :archived, -> { where archived: true }
  scope :unarchived, -> { where archived: false }
  # scope :unarchived, -> { current.joins(:answer_templates).where('answer_templates.archived' => false).group("questions.id").having('count(answer_templates) > 0') }

  # Translations
  localize :text

  # Methods
  def to_param
    slug.blank? ? id : slug
  end

  def self.find_by_param(input)
    if input.class == Question
      input
    else
      self.where("questions.slug = ? or questions.id = ?", input.to_s, input.to_i).first
    end
  end

  def answer_templates=(attribute_list)
    attribute_list.each do |attrs|
      answer_templates.build(attrs)
    end
  end

  # Returns how the community answered to a question and answer template for a given encounter
  def community_answer_values(encounter, answer_template)
    answer_value_scope = AnswerValue.joins(:answer).where(answers: { question_id: self.id, state: 'locked' }, answer_template: answer_template).where.not(answer_option_id: nil)
    if encounter
      answer_value_scope = answer_value_scope.joins(answer: :answer_session).where(answer_sessions: { encounter: encounter.slug })
    end
    answer_value_scope
  end

  # This is for text answers, like date-of-birth
  def community_answer_text_values(encounter)
    answer_template = self.answer_templates.first
    answer_value_scope = AnswerValue.joins(:answer).where(answers: { question_id: self.id, state: 'locked' }, answer_template: answer_template)
    if encounter
      answer_value_scope = answer_value_scope.joins(answer: :answer_session).where(answer_sessions: { encounter: encounter.slug })
    end
    answer_value_scope
  end

  def first_radio_or_checkbox_answer_template
    answer_templates.unarchived.find_by template_name: %w(radio checkbox)
  end
end
