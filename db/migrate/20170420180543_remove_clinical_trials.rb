class RemoveClinicalTrials < ActiveRecord::Migration[5.0]
  def change
    drop_table :admin_clinical_trials do |t|
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
      t.boolean :industry_sponsored, null: false, default: false
      t.integer :position, null: false, default: 0
    end
  end
end
