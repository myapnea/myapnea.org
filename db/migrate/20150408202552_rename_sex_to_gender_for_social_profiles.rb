class RenameSexToGenderForSocialProfiles < ActiveRecord::Migration[4.2]
  def change
    rename_column :social_profiles, :sex, :gender
  end
end
