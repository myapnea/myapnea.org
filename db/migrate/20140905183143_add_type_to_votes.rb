class AddTypeToVotes < ActiveRecord::Migration[4.2]
  def change
    add_column :votes, :label, :string
  end
end
