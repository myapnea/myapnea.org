class CreateEngagements < ActiveRecord::Migration[4.2]
  def change
    create_table :engagements do |t|
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

      t.timestamps null: false
    end

    add_index :engagements, :user_id
  end
end
