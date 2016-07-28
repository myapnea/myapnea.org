class CreateInvites < ActiveRecord::Migration[4.2]
  def change
    create_table :invites do |t|
      t.string :email
      t.integer :user_id
      t.integer :recipient_id
      t.string :token
      t.timestamps null: false
    end
  end
end
