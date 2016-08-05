# frozen_string_literal: true

# A portion of a question used to capture data.
class AnswerTemplate < ApplicationRecord
  # Constants
  TEMPLATE_NAMES = %w(date radio checkbox string height number)

  # Model Relationships
  belongs_to :user
  # TODO: Replace HABTM relationship.
  has_and_belongs_to_many :questions
  has_many :answer_options_answer_templates, -> { order :position }
  has_many :answer_options, through: :answer_options_answer_templates, join_table: 'answr_options_answer_templates'
  belongs_to :display_type
  belongs_to :parent_answer_template, class_name: 'AnswerTemplate', foreign_key: 'parent_answer_template_id'

  # Validations
  validates :name, :user_id, :template_name, presence: true
  validates :name, format: { with: /\A[a-z]\w*\Z/i }, length: { maximum: 32 }
  validates :name, uniqueness: { scope: :deleted }
  validates :template_name, inclusion: { in: TEMPLATE_NAMES }
  validates :parent_answer_template_id, presence: true, if: :parent_answer_option_value_present?
  validates :parent_answer_option_value, presence: true, if: :parent_answer_template_present?
  validates :parent_answer_option_value, inclusion: { in: :parent_template_option_values },
                                         if: :parent_answer_template_present?

  # Concerns
  include Deletable

  # Scopes
  scope :archived, -> { where archived: true }
  scope :unarchived, -> { where archived: false }

  # Methods
  def name_with_options
    "#{name} #{answer_options.pluck(:text, :value).collect { |text, value| "#{value}: #{text}" }.join(', ')}"
  end

  def data_type
    case template_name
    when 'number', 'height'
      'numeric_value'
    when 'radio', 'checkbox'
      'answer_option_id'
    else
      'text_value'
    end
  end

  def allow_multiple?
    template_name == 'checkbox'
  end

  def allows_answer_options?
    template_name == 'radio' || template_name == 'checkbox'
  end

  def child_templates(question, value)
    question.answer_templates.where(parent_answer_template_id: id, parent_answer_option_value: value)
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
  def sorted_answer_options
    answer_options.reorder(:value)
  end

  def csv_column
    if template_name == 'checkbox'
      sorted_answer_options.collect do |answer_option|
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
      sorted_answer_options.collect do |answer_option|
        "  informat #{option_template_name(answer_option.value)} best32. ;"
      end
    else
      "  informat #{sas_name} #{sas_informat}. ;"
    end
  end

  def sas_format_definition
    if template_name == 'checkbox'
      sorted_answer_options.collect do |answer_option|
        "  format #{option_template_name(answer_option.value)} best32. ;"
      end
    else
      "  format #{sas_name} #{sas_format}. ;"
    end
  end

  def sas_format_label
    display_name = full_label
    if template_name == 'checkbox'
      sorted_answer_options.collect do |answer_option|
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

  def full_label
    [questions.first.text_en.to_s.chomp, text.to_s.chomp].reject(&:blank?).join(' ')
  end

  def sas_value_domain
    if sorted_answer_options.count > 0
      answer_options_strings = sorted_answer_options.collect do |ao|
        "    #{ao.value}='#{ao.value}: #{ao.text.to_s.gsub("'", "''")}'"
      end
      "  value #{sas_domain_name}\n#{answer_options_strings.join("\n")}\n  ;"
    else
      []
    end
  end

  def sas_domain_name
    "#{sas_name}f"
  end

  def sas_format_domain
    if sorted_answer_options.count > 0
      if template_name == 'checkbox'
        sorted_answer_options.collect do |answer_option|
          "  format #{option_template_name(answer_option.value)} #{sas_domain_name}. ;"
        end
      else
        "  format #{sas_name} #{sas_domain_name}. ;"
      end
    else
      nil
    end
  end

  def max_position
    answer_options_answer_templates.pluck(:position).compact.max || -1
  end
end
