class AddTextToAnswerTemplate < ActiveRecord::Migration[4.2]
  def change
    add_column :answer_templates, :text, :string
  end
end
