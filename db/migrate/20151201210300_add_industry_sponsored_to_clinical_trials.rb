class AddIndustrySponsoredToClinicalTrials < ActiveRecord::Migration[4.2]
  def change
    add_column :admin_clinical_trials, :industry_sponsored, :boolean, null: false, default: false
  end
end
