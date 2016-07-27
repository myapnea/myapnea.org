class RenameQuestionNumberToPosition < ActiveRecord::Migration[4.2]
  def change
    rename_column :survey_question_orders, :question_number, :position
  end
end
