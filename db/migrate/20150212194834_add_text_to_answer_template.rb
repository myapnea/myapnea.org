class AddTextToAnswerTemplate < ActiveRecord::Migration
  def change
    add_column :answer_templates, :text, :string
  end
end
