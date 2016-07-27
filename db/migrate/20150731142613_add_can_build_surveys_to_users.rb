class AddCanBuildSurveysToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :can_build_surveys, :boolean, null: false, default: false
  end
end
