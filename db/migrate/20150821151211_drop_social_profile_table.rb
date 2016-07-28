class DropSocialProfileTable < ActiveRecord::Migration[4.2]
  def up
    drop_table :social_profiles
  end

  def down
    create_table :social_profiles do |t|
      t.string :name
      t.integer :age
      t.string :gender
      # Profile Photo
      t.string :photo
      # Geocoding
      t.float :latitude
      t.float :longitude
      t.string :location_id
      t.string :location
      t.boolean :show_location, default: false, null: false
      t.boolean :show_karma, default: false, null: false
      # User Foreign Key
      t.integer :user_id
      # Forem
      t.timestamp :accepted_forum_rules_at
      t.timestamps
      t.boolean :visible_to_community, default: false, null: false
      t.boolean :visible_to_world, default: false, null: false
      t.boolean :make_public, default: false, null: false
      t.boolean :deleted, default: false, null: false
    end
  end
end
