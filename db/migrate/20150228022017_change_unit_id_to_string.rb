class ChangeUnitIdToString < ActiveRecord::Migration[4.2]
  def change
    remove_column :answer_templates, :unit_id, :integer
    add_column :answer_templates, :unit, :string
  end
end
