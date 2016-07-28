class AddForemAdmin < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :forem_admin, :boolean, default: false
  end
end
