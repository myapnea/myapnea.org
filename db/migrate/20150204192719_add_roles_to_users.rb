class AddRolesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :boolean, null: false, default: false
    add_column :users, :researcher, :boolean, null: false, default: false
    add_column :users, :adult_diagnosed, :boolean, null: false, default: false
    add_column :users, :adult_at_risk, :boolean, null: false, default: false
    add_column :users, :caregiver_adult, :boolean, null: false, default: false
    add_column :users, :caregiver_child, :boolean, null: false, default: false
  end
end
