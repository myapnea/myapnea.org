namespace :profiles do
  desc "Move all social profile images and provider images to user images."
  task move_images: :environment do
    uploads_folder = File.join(Rails.root, 'public', 'uploads')
    social_profile_images_folder = File.join(uploads_folder, 'social_profile', 'photo')
    provider_images_folder = File.join(uploads_folder, 'provider', 'photo')
    user_images_folder = File.join(uploads_folder, 'user', 'photo')

    mkdir_p user_images_folder

    # Move all social profile images to user folder
    (Dir.entries(social_profile_images_folder) - ['.', '..', '.DS_Store']).each do |entry|
      input = File.join(social_profile_images_folder, entry)
      output = File.join(user_images_folder, entry)
      unless File.directory?(output)
        puts "\nMoving #{input}\nTo     #{output}"
        FileUtils.cp_r input, output, verbose: true
      end
    end

    # Move all provider images to user folder
    (Dir.entries(provider_images_folder) - ['.', '..', '.DS_Store']).each do |entry|
      input = File.join(provider_images_folder, entry)
      output = File.join(user_images_folder, entry)
      unless File.directory?(output)
        puts "\nMoving #{input}\nTo     #{output}"
        FileUtils.cp_r input, output, verbose: true
      end
    end

  end

  # Merges information from social profile into user model
  task merge: :environment do
    SocialProfile.includes(:user).each do |social_profile|
      if social_profile.user
        forum_name = social_profile.name.to_s.gsub('@gmail.com','').gsub('@','at').gsub(/[^a-zA-Z0-9]/, '').strip
        # if forum_name != social_profile.name.to_s
        #   # puts "Social Profile name changed from '#{social_profile.name}' to '#{forum_name}'"
        # elsif forum_name.present?
        #   # puts "Social Profile name set to '#{forum_name}'"
        # end

        if forum_name.blank?
          forum_name = nil
        end

        if social_profile.user.update forum_name: forum_name, age: social_profile.age, gender: social_profile.gender
        else
          puts "COULD NOT SAVE User ##{social_profile.user.id} FORUM NAME: '#{forum_name}' Social Profile Name: #{social_profile.name} Posts #{social_profile.user.posts.count}"
          if similar_user = User.where(forum_name: forum_name).first
            puts "similar_user found: User ##{similar_user.id} Forum_name: #{similar_user.forum_name} Social Profile Name: #{similar_user.social_profile.name if similar_user.social_profile}  Posts #{similar_user.posts.count}"
          end
        end
      end
    end

    User.where(forum_name: [nil, '']).each do |user|
      forum_name = SocialProfile.generate_forum_name(user.email)
      if user.update forum_name: forum_name
      else
        puts "COULD NOT SAVE User ##{user.id} FORUM NAME: '#{forum_name}'"
      end
    end

    SocialProfile.includes(:user).each do |social_profile|
      if social_profile.user and social_profile.photo
        social_profile.user.update photo: social_profile.photo
      end
    end

  end

end
