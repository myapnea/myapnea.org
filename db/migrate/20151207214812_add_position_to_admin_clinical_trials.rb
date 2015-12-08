class AddPositionToAdminClinicalTrials < ActiveRecord::Migration
  def change
    add_column :admin_clinical_trials, :position, :integer, null: false, default: 0
  end
end
