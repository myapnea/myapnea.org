class AddDiagnosedToChildren < ActiveRecord::Migration
  def change
    add_column :children, :diagnosed, :boolean, default: false, null: false
  end
end
