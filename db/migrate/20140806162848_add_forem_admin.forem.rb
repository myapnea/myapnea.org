# This migration comes from forem (originally 20120616193446)
class AddForemAdmin < ActiveRecord::Migration
  def change
    unless column_exists?(:users, :forem_admin)
      add_column :users, :forem_admin, :boolean, :default => false
    end
  end
end
