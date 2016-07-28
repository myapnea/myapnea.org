class AddFriendlyIdSlugs < ActiveRecord::Migration[4.2]
  def change
    add_column :forem_forums, :slug, :string
    add_index :forem_forums, :slug, unique: true
    add_column :forem_categories, :slug, :string
    add_index :forem_categories, :slug, unique: true
    add_column :forem_topics, :slug, :string
    add_index :forem_topics, :slug, unique: true
  end
end
