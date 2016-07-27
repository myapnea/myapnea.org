class AddDeletedToSurveys < ActiveRecord::Migration[4.2]
  def change
    add_column :surveys, :deleted, :boolean, null: false, default: false
  end
end
