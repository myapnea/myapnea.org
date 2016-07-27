class RenameTopicsStateToStatus < ActiveRecord::Migration[4.2]
  def change
    rename_column :topics, :state, :status
  end
end
