class RenameSexToGenderForSocialProfiles < ActiveRecord::Migration
  def change
    rename_column :social_profiles, :sex, :gender
  end
end
