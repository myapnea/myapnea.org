class DropEngagementsTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :engagements do |t|
      t.integer :user_id
      t.boolean :adult_diagnosed, null: false, default: false
      t.boolean :adult_at_risk, null: false, default: false
      t.boolean :caregiver_adult, null: false, default: false
      t.boolean :caregiver_child, null: false, default: false
      t.boolean :researcher, null: false, default: false
      t.boolean :provider, null: false, default: false
      t.boolean :deleted, null: false, default: false
      t.string :text
      t.string :response_placeholder
      t.timestamps
      t.index :user_id
    end
  end
end
