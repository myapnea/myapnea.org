class AddDiagnosedToSurvey < ActiveRecord::Migration[4.2]
  def change
    add_column :surveys, :pediatric_diagnosed, :boolean, null: false, default: false
  end
end
