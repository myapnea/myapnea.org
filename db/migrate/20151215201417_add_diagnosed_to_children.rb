class AddDiagnosedToChildren < ActiveRecord::Migration[4.2]
  def change
    add_column :children, :diagnosed, :boolean, default: false, null: false
  end
end
