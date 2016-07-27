class AddMakePublicToSocialProfile < ActiveRecord::Migration[4.2]
  def change
    add_column :social_profiles, :make_public, :boolean, default: false, null: false
  end
end
