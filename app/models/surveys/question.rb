class Question < ActiveRecord::Base
  # Constants
  DISPLAY_TYPE = ["custom_date_input", "radio_input", "checkbox_input", "height_input", "number_input", "radio_input_multiple"]

  # Concerns
  include Localizable
  include Votable
  include Deletable

  # Translations
  localize :text

  # Model Validation
  validates_presence_of :text_en, :slug, :user_id, :display_type
  validates_uniqueness_of :slug, scope: [ :deleted ]
  validates_format_of :slug, with: /\A(?!\Anew\Z)[a-z][a-z0-9\-]*\Z/

  # Model Relationships
  belongs_to :user
  has_and_belongs_to_many :answer_templates, -> { current.order("answer_templates.created_at asc") }
  belongs_to :group
  has_many :answers, -> { where deleted: false }
  belongs_to :question_help_message
  has_many :survey_answer_frequencies
  has_many :votes
  has_many :reports

  # Model Methods

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

  def applicable_to_user?(answer_session)
    answer_session.applicable_questions.where(id: self.id).exists?
  end

  def user_skipped_question?(answer_session)
    applicable_to_user?(answer_session) and (answer_session.answers.where(question_id: self.id).select{|answer| answer.show_value.blank?}.exists?)
  end

end
