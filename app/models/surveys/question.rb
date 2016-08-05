# frozen_string_literal: true

class Question < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :answer_templates_questions, -> { order :position }
  has_many :answer_templates, through: :answer_templates_questions
  belongs_to :group
  has_many :answers
  belongs_to :question_help_message
  has_many :votes

  # Validations
  validates :text_en, :user_id, :slug, presence: true
  validates :slug, uniqueness: { scope: :deleted }
  validates :slug, format: /\A(?!\Anew\Z)[a-z][a-z0-9\-]*\Z/

  # Concerns
  include Localizable
  include Deletable

  # Scopes
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
      # TODO change to new "OR#relation" syntax
      where('questions.slug = ? or questions.id = ?', input.to_s, input.to_i).first
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

  def max_position
    answer_templates_questions.pluck(:position).compact.max || -1
  end
end
