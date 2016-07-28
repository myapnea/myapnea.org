class UpdateSocialProfile < ActiveRecord::Migration[4.2]
  def change
    add_column :social_profiles, :visible_to_community, :boolean, default: false, null: false
    add_column :social_profiles, :visible_to_world, :boolean, default: false, null: false
  end
end
