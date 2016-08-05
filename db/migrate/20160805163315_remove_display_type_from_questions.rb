class RemoveDisplayTypeFromQuestions < ActiveRecord::Migration[5.0]
  def change
    remove_column :questions, :display_type, :string
  end
end
