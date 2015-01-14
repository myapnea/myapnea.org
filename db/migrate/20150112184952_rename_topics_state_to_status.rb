class RenameTopicsStateToStatus < ActiveRecord::Migration
  def change
    rename_column :topics, :state, :status
  end
end
