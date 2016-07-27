class AddPositionToAnswerOptionAnswerTemplates < ActiveRecord::Migration[4.2]
  def change
    add_column :answr_options_answer_templates, :position, :integer, null: false, default: 0
    add_index :answr_options_answer_templates, :position
  end
end
