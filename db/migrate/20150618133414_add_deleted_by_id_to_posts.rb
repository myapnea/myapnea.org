class AddDeletedByIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :deleted_by_id, :integer
    add_index :posts, :deleted_by_id
  end
end
