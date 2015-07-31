class AddDeletedToSurveys < ActiveRecord::Migration
  def change
    add_column :surveys, :deleted, :boolean, null: false, default: false
  end
end
