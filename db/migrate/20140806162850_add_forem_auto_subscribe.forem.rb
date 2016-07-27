# This migration comes from forem (originally 20120616193448)
class AddForemAutoSubscribe < ActiveRecord::Migration[4.2]
  def change
    unless column_exists?(:users, :forem_auto_subscribe)
      add_column :users, :forem_auto_subscribe, :boolean, :default => false
    end
  end
end
