class DropResearchArticlesTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :admin_research_articles do |t|
      t.string :title
      t.string :slug
      t.text :description
      t.text :content
      t.integer :position, null: false, default: 0
      t.string :photo
      t.boolean :deleted, null: false, default: false
      t.string :author
      t.string :credentials
      t.text :references
      t.integer :research_topic_id
      t.string :keywords
      t.timestamps null: false
      t.index :position
      t.index :research_topic_id
    end
  end
end
