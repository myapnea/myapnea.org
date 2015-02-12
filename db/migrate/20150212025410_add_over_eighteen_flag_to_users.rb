class AddOverEighteenFlagToUsers < ActiveRecord::Migration
  def change
    add_column :users, :over_eighteen, :boolean, null: false, default: false
  end
end
