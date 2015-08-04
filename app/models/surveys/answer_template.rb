class AnswerTemplate < ActiveRecord::Base
  # Constants
  DATA_TYPE = ["answer_option_id", "numeric_value", "text_value"]

  # Concerns
  include Deletable

  # Model Validation
  validates_presence_of :name, :data_type, :user_id
  validates_uniqueness_of :name, scope: [ :deleted ]

  # Model Relationships
  belongs_to :user
  has_and_belongs_to_many :questions
  has_many :answer_options_answer_templates, -> { order("answr_options_answer_templates.created_at") }
  has_many :answer_options, through: :answer_options_answer_templates, join_table: 'answr_options_answer_templates'
  belongs_to :display_type
  has_many :reports


  # Model Methods

  # Temporary Function
  def template_name
    question = self.questions.first
    if question
      if question.display_type == "custom_date_input"        and self.data_type == "text_value"
        'date'
      elsif question.display_type == "radio_input"           and self.data_type == "answer_option_id"
        'radio'
      elsif question.display_type == "checkbox_input"        and self.data_type == "answer_option_id"
        'checkbox'
      elsif question.display_type == "checkbox_input"        and self.data_type == "text_value"
        'string'
      elsif question.display_type == "height_input"          and self.data_type == "numeric_value"
        'height'
      elsif question.display_type == "number_input"          and self.data_type == "numeric_value"
        'number'
      elsif question.display_type == "radio_input_multiple"  and self.data_type == "answer_option_id"
        'radio'
      elsif question.display_type == "radio_input"           and self.data_type == "text_value"
        'string'
      else
        nil
      end
    else
      nil
    end
  end

  def next_target_template(value)
    question = self.questions.first
    if question
      question.answer_templates.where(target_answer_option: value).first
    else
      nil
    end
  end

  # Preprocessing Functions
  def self.height_conversion(val)
    if val.empty?
      return_val = nil
    else
      return_val = (val["feet"].to_i * 12 + val["inches"].to_i)
      return_val = nil if return_val == 0
    end

    return_val
  end

  def self.inverse_height_conversion(val)
    if val.blank?
      {}
    else
      res = {}
      res['feet'] = val.to_i / 12
      res['inches'] = val - (res['feet'] * 12)
      res
    end
  end

  def preprocess_value(val)
    if preprocess.present?
      AnswerTemplate.send(preprocess, val)
    else
      val
    end
  end

  def postprocess_value(val)
    if preprocess.present? and val.present? and val[self.id].present?
      AnswerTemplate.send("inverse_#{preprocess}", val[self.id])
    else
      val
    end
  end
end
