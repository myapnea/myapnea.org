class RemoveRoleTables < ActiveRecord::Migration[4.2]
  def up
    drop_table :roles_users
    drop_table :roles
  end

  def down
    create_table(:roles) do |t|
      t.string :name
      t.references :resource, polymorphic: true

      t.timestamps
    end

    create_table(:roles_users, id: false) do |t|
      t.references :user
      t.references :role
    end

    add_index(:roles, :name)
    add_index(:roles, [ :name, :resource_type, :resource_id ])
    add_index(:roles_users, [ :user_id, :role_id ])
  end
end
