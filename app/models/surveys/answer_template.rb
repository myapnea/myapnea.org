class AnswerTemplate < ActiveRecord::Base
  # Constants
  DATA_TYPE = ["answer_option_id", "numeric_value", "text_value", "time_value"]

  # Concerns
  include Deletable

  # Model Validation
  validates_presence_of :name, :data_type, :user_id
  validates_uniqueness_of :name, scope: [ :deleted ]

  # Model Relationships
  belongs_to :user
  has_and_belongs_to_many :questions
  has_many :answer_options_answer_templates, -> { order "answr_options_answer_templates.created_at" }
  has_many :answer_options, through: :answer_options_answer_templates, join_table: 'answr_options_answer_templates'
  belongs_to :display_type
  has_many :reports


  # Model Methods

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
