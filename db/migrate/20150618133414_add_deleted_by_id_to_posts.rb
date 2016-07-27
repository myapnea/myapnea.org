class AddDeletedByIdToPosts < ActiveRecord::Migration[4.2]
  def change
    add_column :posts, :deleted_by_id, :integer
    add_index :posts, :deleted_by_id
  end
end
