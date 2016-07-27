# frozen_string_literal: true

class AnswerOptionsAnswerTemplate < ApplicationRecord
  self.table_name = 'answr_options_answer_templates'

  belongs_to :answer_template, -> { where deleted: false }
  belongs_to :answer_option, -> { where deleted: false }
end
