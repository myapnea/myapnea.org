class RemoveUserRoles < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :first_name, :string
    remove_column :users, :last_name, :string
    remove_column :users, :state_code, :string
    remove_column :users, :country_code, :string
    remove_column :users, :user_type, :string
    remove_column :users, :provider, :boolean, null: false, default: false
    remove_column :users, :researcher, :boolean, null: false, default: false
    remove_column :users, :adult_diagnosed, :boolean, null: false, default: false
    remove_column :users, :adult_at_risk, :boolean, null: false, default: false
    remove_column :users, :caregiver_adult, :boolean, null: false, default: false
    remove_column :users, :caregiver_child, :boolean, null: false, default: false
    remove_column :users, :accepted_consent_at, :datetime
    remove_column :users, :accepted_privacy_policy_at, :datetime
    remove_column :users, :accepted_terms_conditions_at, :datetime
    remove_column :users, :accepted_terms_of_access_at, :datetime
    remove_column :users, :accepted_update_at, :datetime
    remove_column :users, :can_build_surveys, :boolean, null: false, default: false
    remove_index :users, :outgoing_heh_token
    remove_index :users, :incoming_heh_token
    remove_column :users, :outgoing_heh_at, :datetime
    remove_column :users, :outgoing_heh_token, :string
    remove_column :users, :incoming_heh_at, :datetime
    remove_column :users, :incoming_heh_token, :string
  end
end
