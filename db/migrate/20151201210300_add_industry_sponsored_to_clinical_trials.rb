class AddIndustrySponsoredToClinicalTrials < ActiveRecord::Migration
  def change
    add_column :admin_clinical_trials, :industry_sponsored, :boolean, null: false, default: false
  end
end
