# This migration comes from forem (originally 20120616193447)
class AddForemState < ActiveRecord::Migration
  def change
    unless column_exists?(:users, :forem_state)
      add_column :users, :forem_state, :string, :default => 'pending_review'
    end
  end
end
