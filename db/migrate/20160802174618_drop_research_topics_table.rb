class DropResearchTopicsTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :research_topics do |t|
      t.integer :user_id
      t.boolean :deleted, null: false, default: false
      t.string :progress
      t.integer :topic_id
      t.string :category, null: false, default: 'user_submitted'
      t.timestamps
      t.index :topic_id
    end
  end
end
