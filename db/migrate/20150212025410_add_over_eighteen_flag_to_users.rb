class AddOverEighteenFlagToUsers < ActiveRecord::Migration
  def change
    add_column :users, :over_eighteen, :boolean, null: true
  end
end
