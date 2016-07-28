class CreateAdminTeamMembers < ActiveRecord::Migration[4.2]
  def change
    create_table :admin_team_members do |t|
      t.string :name
      t.string :designations
      t.string :role
      t.string :group
      t.integer :position, default: 10
      t.text :bio
      t.string :photo
      t.boolean :deleted, default: false, null: false
      t.timestamps null: false
    end
  end
end
