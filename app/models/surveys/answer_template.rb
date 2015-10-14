class AnswerTemplate < ActiveRecord::Base
  # Constants
  DATA_TYPES = ["answer_option_id", "numeric_value", "text_value"]
  TEMPLATE_NAMES = %w(date radio checkbox string height number)

  # Concerns
  include Deletable

  # Callbacks
  before_validation :set_data_type
  before_validation :set_allow_multiple

  # Model Validation
  validates_presence_of :name, :data_type, :user_id, :template_name
  validates_uniqueness_of :name, scope: [ :deleted ]
  validates_inclusion_of :template_name, in: TEMPLATE_NAMES
  validates_presence_of :parent_answer_template_id, if: :parent_answer_option_value_present?
  validates_presence_of :parent_answer_option_value, if: :parent_answer_template_present?
  validates_inclusion_of :parent_answer_option_value, in: :parent_template_option_values, if: :parent_answer_template_present?

  # Model Relationships
  belongs_to :user
  has_and_belongs_to_many :questions
  has_many :answer_options_answer_templates, -> { order("answr_options_answer_templates.created_at") }
  has_many :answer_options, through: :answer_options_answer_templates, join_table: 'answr_options_answer_templates'
  belongs_to :display_type
  belongs_to :parent_answer_template, class_name: "AnswerTemplate", foreign_key: "parent_answer_template_id"

  # Model Methods

  def name_with_options
    "#{name} #{answer_options.pluck(:text, :value).collect { |text, value| "#{value}: #{text}" }.join(', ')}"
  end

  # Temporary Function (Rewrite/remove in 8.1)

  # Will replace "data_type" and be renamed to simply "data_type" when data_type
  # is removed as a database column.
  def stored_data_type
    case template_name when 'number', 'height'
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
  # End Rewrite In 8.1

  def allows_answer_options?
    template_name == 'radio' || template_name == 'checkbox'
  end

  def child_templates(question, value)
    question.answer_templates.where(parent_answer_template_id: self.id, parent_answer_option_value: value)
  end

  def parent_answer_option_value_present?
    parent_answer_option_value.present?
  end

  def parent_answer_option_id
    parent_answer_template.answer_options.find_by_value(parent_answer_option_value).id
  end

  def parent_answer_template_present?
    parent_answer_template.present?
  end

  def parent_template_option_values
    if parent_answer_template
      parent_answer_template.answer_options.pluck(:value)
    else
      []
    end
  end

  # For Exports
  def csv_column
    if template_name == 'checkbox'
      [sas_name] + answer_options.collect do |answer_option|
        option_template_name(answer_option.value)
      end
    else
      sas_name
    end
  end

  def sas_informat
    case template_name
    when 'date'
      'yymmdd10'
    when 'radio', 'checkbox', 'height', 'number'
      'best32'
    when 'string'
      '$500'
    else
      '$5000'
    end
  end

  def sas_format
    sas_informat
  end

  def sas_informat_definition
    if template_name == 'checkbox'
      option_informat = 'best32'
      ["  informat #{sas_name} #{sas_informat}. ;"] + answer_options.collect do |answer_option|
        "  informat #{option_template_name(answer_option.value)} best32. ;"
      end
    else
      "  informat #{sas_name} #{sas_informat}. ;"
    end
  end

  def sas_format_definition
    if template_name == 'checkbox'
      ["  format #{sas_name} #{sas_format}. ;"] + answer_options.collect do |answer_option|
        "  format #{option_template_name(answer_option.value)} best32. ;"
      end
    else
      "  format #{sas_name} #{sas_format}. ;"
    end
  end

  def sas_format_label
    display_name = sas_name
    if template_name == 'checkbox'
      ["  label #{sas_name}='#{display_name.gsub("'", "''")}';"] + answer_options.collect do |answer_option|
        "  label #{option_template_name(answer_option.value)}='#{display_name.gsub("'", "''")} (#{answer_option.text.to_s.gsub("'", "''")})' ;"
      end
    else
      "  label #{sas_name}='#{display_name.gsub("'", "''")}';"
    end
  end

  def option_template_name(value)
    "#{sas_name}__#{value}".last(28)
  end

  def sas_name
    name.gsub('-', '_').last(28)
  end
end
