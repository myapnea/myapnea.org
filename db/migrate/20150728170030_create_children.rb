class CreateChildren < ActiveRecord::Migration[4.2]
  def change
    create_table :children do |t|
      t.integer :user_id
      t.string :first_name
      t.integer :age
      t.datetime :accepted_consent_at
      t.boolean :deleted

      t.timestamps null: false
    end

    add_index :children, :user_id
    add_index :children, :deleted
    add_index :children, [:user_id, :deleted]
  end
end
