class RemoveOverEighteenFromUsers < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :over_eighteen, :boolean
  end
end
