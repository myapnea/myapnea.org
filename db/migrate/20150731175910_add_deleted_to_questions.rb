class AddDeletedToQuestions < ActiveRecord::Migration[4.2]
  def change
    add_column :questions, :deleted, :boolean, null: false, default: false
  end
end
