class AnswerOption < ActiveRecord::Base
  include Localizable

  has_many :answer_templates, through: :answer_options_answer_templates, join_table: :answr_options_answer_templates
  has_many :answer_values
  has_many :survey_answer_frequencies

  localize :text_value

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
end
