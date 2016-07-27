class DropGroupsTable < ActiveRecord::Migration[4.2]
  def up
    remove_column :questions, :group_id
    drop_table :groups
  end

  def down
    create_table :groups do |t|
      t.string :name
    end
    add_column :questions, :group_id, :integer
  end
end
