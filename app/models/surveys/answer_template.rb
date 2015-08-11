class AnswerTemplate < ActiveRecord::Base
  # Constants
  DATA_TYPES = ["answer_option_id", "numeric_value", "text_value"]
  TEMPLATE_NAMES = ["date", "radio", "checkbox", "string", "height", "number"]

  # Concerns
  include Deletable

  # Callbacks
  before_validation :set_data_type
  before_validation :set_allow_multiple

  # Model Validation
  validates_presence_of :name, :data_type, :user_id, :template_name
  validates_uniqueness_of :name, scope: [ :deleted ]
  validates_inclusion_of :template_name, in: TEMPLATE_NAMES
  validates_presence_of :parent_answer_template_id, if: :target_answer_option_present?
  validates_presence_of :target_answer_option, if: :parent_answer_template_present?
  validates_inclusion_of :target_answer_option, in: :parent_template_option_values, if: :parent_answer_template_present?

  # Model Relationships
  belongs_to :user
  has_and_belongs_to_many :questions
  has_many :answer_options_answer_templates, -> { order("answr_options_answer_templates.created_at") }
  has_many :answer_options, through: :answer_options_answer_templates, join_table: 'answr_options_answer_templates'
  belongs_to :display_type
  has_many :reports
  belongs_to :parent_answer_template, class_name: "AnswerTemplate", foreign_key: "parent_answer_template_id"

  # Model Methods

  def name_with_options
    "#{self.name} #{self.answer_options.pluck(:text, :value).collect{|text, value| "#{value}: #{text}"}.join(', ')}"
  end

  # Temporary Function
  def set_template_name!
    new_template_name = nil
    question = self.questions.first
    if question
      new_template_name = if question.display_type == "custom_date_input" and self.data_type == "text_value"
        'date'
      elsif question.display_type == "radio_input"           and self.data_type == "answer_option_id"
        'radio'
      elsif question.display_type == "checkbox_input"        and self.data_type == "answer_option_id"
        if self.target_answer_option == nil
          'checkbox'
        else
          'radio'
        end
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
    self.update template_name: new_template_name
  end

  # Will replace "data_type" and be renamed to simply "data_type" when data_type
  # is removed as a database column.
  def stored_data_type
    case self.template_name when 'number', 'height'
      'numeric_value'
    when 'radio', 'checkbox'
      'answer_option_id'
    else # 'date', 'string'
      'text_value'
    end
  end

  def set_data_type
    self.data_type = self.stored_data_type
    true # Before Validations need to return true in order to save record
  end

  def set_allow_multiple
    self.allow_multiple = (self.template_name == 'checkbox')
    true # Before Validations need to return true in order to save record
  end

  def child_templates(question, value)
    question.answer_templates.where(parent_answer_template_id: self.id, target_answer_option: value)
  end

  def target_answer_option_present?
    self.target_answer_option.present?
  end

  def parent_answer_template_present?
    self.parent_answer_template.present?
  end

  def parent_template_option_values
    if self.parent_answer_template
      self.parent_answer_template.answer_options.pluck(:value)
    else
      []
    end
  end
end
