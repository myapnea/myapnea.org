class CreateAdminClinicalTrials < ActiveRecord::Migration
  def change
    create_table :admin_clinical_trials do |t|
      t.string :title
      t.string :overview
      t.text :description
      t.text :eligibility
      t.string :phone
      t.string :email
      t.string :link
      t.boolean :deleted, null: false, default: false
      t.boolean :displayed, null: false, default: true

      t.timestamps null: false
    end
  end
end
