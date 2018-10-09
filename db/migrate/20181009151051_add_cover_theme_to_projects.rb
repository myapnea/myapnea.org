class AddCoverThemeToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :cover_theme, :string
  end
end
