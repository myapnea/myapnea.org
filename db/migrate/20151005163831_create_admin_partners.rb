class CreateAdminPartners < ActiveRecord::Migration
  def change
    create_table :admin_partners do |t|
      t.string :name
      t.string :description
      t.string :photo
      t.string :link
      t.string :group
      t.integer :position
      t.boolean :deleted, default: false, null: false
      t.boolean :displayed, default: true, null: false

      t.timestamps null: false
    end
  end
end
