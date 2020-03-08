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

  task subjects: :environment do
    file_path = Rails.root.join("tmp", "subjects-#{Time.zone.today.strftime("%Y%m%d")}.csv")
    CSV.open(file_path, "wb") do |csv|
      puts "Starting...\n"
      csv << ["MyApnea ID", "Slice Subject ID", "Slice Subject Code", "Consented", "Consent Revoked"]
      subjects = Subject.joins(:user).merge(User.current.no_spammer_or_shadow_banned)
      subject_count = subjects.count

      subjects.each_with_index do |subject, index|
        print "\r#{index + 1} of #{subject_count} (#{(index + 1) * 100 / subject_count}%)"
        csv << [
          subject.user.myapnea_id,
          subject.slice_subject_id,
          subject.slice_subject_code_cache,
          subject.consented_at&.to_date,
          subject.consent_revoked_at&.to_date
        ]
      end
      puts "\n...DONE"
      puts file_path
    end
  end
end
