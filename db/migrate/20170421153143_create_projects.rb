class CreateProjects < ActiveRecord::Migration[5.0]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :slug
      t.string :short_description
      t.integer :user_id
      t.text :consent
      t.string :theme
      t.date :launch_date
      t.boolean :deleted, null: false, default: false
      t.timestamps
      t.index :slug, unique: true
      t.index :user_id
      t.index :deleted
    end
  end
end
