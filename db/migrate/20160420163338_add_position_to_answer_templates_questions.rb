class AddPositionToAnswerTemplatesQuestions < ActiveRecord::Migration
  def change
    add_column :answer_templates_questions, :position, :integer, null: false, default: 0
    add_index :answer_templates_questions, :position
  end
end
