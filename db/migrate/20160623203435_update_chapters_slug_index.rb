class UpdateChaptersSlugIndex < ActiveRecord::Migration
  def up
    remove_index :chapters, :slug
    add_index :chapters, :slug, unique: true
  end

  def down
    remove_index :chapters, :slug
    add_index :chapters, :slug
  end
end
