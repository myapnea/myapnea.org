class CreateAdminResearchArticles < ActiveRecord::Migration[4.2]
  def change
    create_table :admin_research_articles do |t|
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

      t.timestamps null: false
    end

    add_index :admin_research_articles, :position
  end
end
