class AddMissingTaggableIndex < ActiveRecord::Migration[4.2]
  def change
    add_index :taggings, [:taggable_id, :taggable_type, :context]
  end
end
