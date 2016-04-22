class RenameQuestionNumberToPosition < ActiveRecord::Migration
  def change
    rename_column :survey_question_orders, :question_number, :position
  end
end
