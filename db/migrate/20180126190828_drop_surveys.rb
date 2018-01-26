class DropSurveys < ActiveRecord::Migration[5.2]
  def change
    drop_table :surveys do |t|
      t.string :name_en
      t.string :name_es
      t.text :description_en
      t.text :description_es
      t.string :status
      t.datetime :created_at
      t.datetime :updated_at
      t.string :short_description_en
      t.string :short_description_es
      t.string :slug
      t.string :version
      t.integer :default_position, default: 99999, null: false
      t.integer :user_id
      t.boolean :deleted, default: false, null: false
      t.boolean :pediatric, default: false, null: false
      t.integer :child_min_age
      t.integer :child_max_age
      t.boolean :pediatric_diagnosed, default: false, null: false
      t.index :slug
      t.index :user_id
    end
  end
end
