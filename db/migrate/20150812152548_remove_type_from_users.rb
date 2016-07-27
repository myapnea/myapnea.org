class RemoveTypeFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :type, :string
  end
end
