class AddDiagnosedToSurvey < ActiveRecord::Migration
  def change
    add_column :surveys, :pediatric_diagnosed, :boolean, null: false, default: false
  end
end
