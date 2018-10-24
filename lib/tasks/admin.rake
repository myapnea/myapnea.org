namespace :admin do
  desc "Admin export."
  task users: :environment do
    CSV.open(Rails.root.join("tmp", "users-#{Time.zone.today.strftime("%Y%m%d")}.csv"), "wb") do |csv|
      puts "Starting...\n"
      csv << ["MyApnea ID", "Joined", "Sign In Count", "Posts"]
      users = User.current.no_spammer_or_shadow_banned.order(:id)
      user_count = users.count
      users.each_with_index do |user, index|
        print "\r#{index + 1} of #{user_count} (#{(index + 1) * 100 / user_count}%)"
        csv << [
          user.myapnea_id,
          user.created_at.to_date,
          user.sign_in_count,
          user.replies_count
        ]
      end
      puts "\n...DONE"
    end
  end
end
