# frozen_string_literal: true

class AnswerOption < ApplicationRecord
  # Concerns
  include Deletable
  include Localizable

  # Model Validation
  validates_presence_of :text, :hotkey, :value, :user_id
  # validates_uniqueness_of :text, scope: [ :deleted ]

  # Model Relationships
  belongs_to :user
  has_many :answer_options_answer_templates
  has_many :answer_templates, through: :answer_options_answer_templates, join_table: :answr_options_answer_templates
  has_many :answer_values
  has_many :survey_answer_frequencies

  localize :text_value

  # Model Methods

  def value
    text_value || time_value || numeric_value || self[:value]
  end

  def new_value
    self[:value]
  end

  def text
    text_value || self[:text]
  end

  def to_s
    self[:text] || self[:text_value_en]
  end

  def display_class_or_default
    self.display_class.present? ? self.display_class : 'label-default label-sm'
  end

end
