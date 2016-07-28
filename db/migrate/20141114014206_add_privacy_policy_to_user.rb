class AddPrivacyPolicyToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :accepted_privacy_policy_at, :datetime
    add_column :users, :accepted_terms_conditions_at, :datetime
  end
end
