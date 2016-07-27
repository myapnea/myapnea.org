class AddOverEighteenFlagToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :over_eighteen, :boolean, null: true
  end
end
