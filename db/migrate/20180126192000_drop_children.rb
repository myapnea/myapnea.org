class DropChildren < ActiveRecord::Migration[5.2]
  def change
    drop_table :children do |t|
      t.integer :user_id
      t.string :first_name
      t.integer :age
      t.datetime :accepted_consent_at
      t.boolean :diagnosed, default: false, null: false
      t.boolean :deleted
      t.timestamps
      t.index :user_id
      t.index :deleted
      t.index [:user_id, :deleted]
    end
  end
end
