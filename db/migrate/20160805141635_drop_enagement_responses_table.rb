class DropEnagementResponsesTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :engagement_responses do |t|
      t.integer :engagement_id
      t.integer :user_id
      t.text :response
      t.boolean :deleted, null: false, default: false
      t.timestamps
      t.index [:user_id, :engagement_id], unique: true
    end
  end
end
