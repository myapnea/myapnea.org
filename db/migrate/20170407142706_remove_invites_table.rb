class RemoveInvitesTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :invites do |t|
      t.string :email
      t.integer :user_id
      t.integer :recipient_id
      t.string :token
      t.boolean :for_provider, null: false, default: false
      t.boolean :successful, null: false, default: false
      t.timestamps null: false
    end
    remove_column :users, :invite_token, :string
  end
end
