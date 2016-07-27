class AddClassToDisplayType < ActiveRecord::Migration[4.2]
  def change
    add_column :display_types, :class_string, :string
  end
end
