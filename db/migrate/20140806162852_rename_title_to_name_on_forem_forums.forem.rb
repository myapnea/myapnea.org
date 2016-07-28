class RenameTitleToNameOnForemForums < ActiveRecord::Migration[4.2]
  def change
    rename_column :forem_forums, :title, :name
  end
end
