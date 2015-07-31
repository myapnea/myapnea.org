class AddCanBuildSurveysToUsers < ActiveRecord::Migration
  def change
    add_column :users, :can_build_surveys, :boolean, null: false, default: false
  end
end
