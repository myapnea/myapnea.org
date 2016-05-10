# frozen_string_literal: true

namespace :carrierwave do

  task migrate_files_and_folders: :environment do
    uploads_folder = File.join 'public', 'uploads'
    carrierwave_folder = File.join 'carrierwave'
    make_folder carrierwave_folder

    # Copy Highlight Photos
    old_highlight_folder = File.join uploads_folder, 'highlight'
    new_highlights_folder = File.join carrierwave_folder, 'highlights'

    make_folder new_highlights_folder

    (Dir.entries(File.join(old_highlight_folder, 'photo')) - ['.', '..']).each do |highlight_id|
      from = File.join old_highlight_folder, 'photo', highlight_id
      to = File.join new_highlights_folder, highlight_id, 'photo'
      copy_folder from, to
    end

    # Copy User Photos
    old_user_folder = File.join uploads_folder, 'user'
    new_users_folder = File.join carrierwave_folder, 'users'

    make_folder new_users_folder

    (Dir.entries(File.join(old_user_folder, 'photo')) - ['.', '..']).each do |user_id|
      from = File.join old_user_folder, 'photo', user_id
      to = File.join new_users_folder, user_id, 'photo'
      copy_folder from, to
    end

    # Copy Partner Photos
    old_partner_folder = File.join uploads_folder, 'admin', 'partner'
    new_partners_folder = File.join carrierwave_folder, 'admin', 'partners'

    make_folder new_partners_folder

    (Dir.entries(File.join(old_partner_folder, 'photo')) - ['.', '..']).each do |partner_id|
      from = File.join old_partner_folder, 'photo', partner_id
      to = File.join new_partners_folder, partner_id, 'photo'
      copy_folder from, to
    end

    # Copy Team Member Photos
    old_team_member_folder = File.join uploads_folder, 'admin', 'team_member'
    new_team_members_folder = File.join carrierwave_folder, 'admin', 'team_members'

    make_folder new_team_members_folder

    (Dir.entries(File.join(old_team_member_folder, 'photo')) - ['.', '..']).each do |team_member_id|
      from = File.join old_team_member_folder, 'photo', team_member_id
      to = File.join new_team_members_folder, team_member_id, 'photo'
      copy_folder from, to
    end

  end

  def make_folder(folder)
    if File.exist? folder
      puts "      exists".colorize( :blue ) + "  #{folder}"
    else
      puts "      create".colorize( :green ) + "  #{folder}"
    end
    FileUtils.mkdir_p folder
  end

  def copy_folder(from, to)
    make_folder to
    puts "      moving".colorize( :blue ) + "  #{from} => #{to}"
    FileUtils.cp_r File.join(from, '.'), to
  end

end
