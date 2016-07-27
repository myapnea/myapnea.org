class AddPositionToAdminClinicalTrials < ActiveRecord::Migration[4.2]
  def change
    add_column :admin_clinical_trials, :position, :integer, null: false, default: 0
  end
end
