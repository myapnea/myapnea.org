class AddHehColumnsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :outgoing_heh_at, :datetime
    add_column :users, :outgoing_heh_token, :string
    add_column :users, :incoming_heh_at, :datetime
    add_column :users, :incoming_heh_token, :string

    add_index :users, :outgoing_heh_token, unique: true
    add_index :users, :incoming_heh_token, unique: true
  end
end
