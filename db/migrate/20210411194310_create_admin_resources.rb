class CreateAdminResources < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_resources do |t|
      t.string :name
      t.text :description
      t.string :photo
      t.string :link
      t.integer :position
      t.boolean :displayed, default: true, null: false
      t.boolean :deleted, default: false, null: false
      t.timestamps

      t.index :displayed
      t.index :deleted
      t.index :position
    end
  end
end
