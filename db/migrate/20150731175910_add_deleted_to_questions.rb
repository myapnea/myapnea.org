class AddDeletedToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :deleted, :boolean, null: false, default: false
  end
end
