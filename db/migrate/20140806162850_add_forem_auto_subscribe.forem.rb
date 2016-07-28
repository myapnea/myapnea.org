class AddForemAutoSubscribe < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :forem_auto_subscribe, :boolean, default: false
  end
end
