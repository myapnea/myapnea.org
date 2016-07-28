class RolifyCreateRoles < ActiveRecord::Migration[4.2]
  def change
    create_table :roles do |t|
      t.string :name
      t.references :resource, polymorphic: true
      t.timestamps
    end
    add_index :roles, :name

    create_table :roles_users, id: false do |t|
      t.references :user
      t.references :role
    end
    add_index :roles, [:name, :resource_type, :resource_id]
    add_index :roles_users, [:user_id, :role_id]
  end
end
