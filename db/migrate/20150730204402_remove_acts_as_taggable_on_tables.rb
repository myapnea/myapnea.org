class RemoveActsAsTaggableOnTables < ActiveRecord::Migration[4.2]
  def up
    remove_index :tags, :name
    drop_table :tags
    remove_index :taggings, [:taggable_id, :taggable_type, :context]
    remove_index :taggings, name: 'taggings_idx'
    drop_table :taggings
  end

  def down
    create_table :taggings do |t|
      t.integer  :tag_id
      t.integer  :taggable_id
      t.string   :taggable_type
      t.integer  :tagger_id
      t.string   :tagger_type
      t.string   :context,       limit: 128
      t.datetime :created_at
    end

    add_index :taggings, [:tag_id, :taggable_id, :taggable_type, :context, :tagger_id, :tagger_type], unique: true, name: 'taggings_idx'
    add_index :taggings, [:taggable_id, :taggable_type, :context]

    create_table :tags do |t|
      t.string  :name
      t.integer :taggings_count, default: 0
    end

    add_index :tags, :name, unique: true
  end
end
