class AnswerOptionsAnswerTemplate < ActiveRecord::Base
  self.table_name = 'answr_options_answer_templates'

  belongs_to :answer_template, -> { where deleted: false }
  belongs_to :answer_option, -> { where deleted: false }
end
