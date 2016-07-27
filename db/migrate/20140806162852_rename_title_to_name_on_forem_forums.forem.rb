# This migration comes from forem (originally 20121203093719)
class RenameTitleToNameOnForemForums < ActiveRecord::Migration[4.2]
  def up
    rename_column :forem_forums, :title, :name
  end
end
