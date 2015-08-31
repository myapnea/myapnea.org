namespace :surveys do

  desc "Automatically launch followup encounters for users who have filled out a corresponding baseline survey"
  task launch_followup_encounters: :environment do
    Survey.launch_followup_encounters
  end

  desc "Add default baseline encounter."
  task add_baseline_encounter: :environment do
    ActiveRecord::Base.connection.execute("TRUNCATE encounters RESTART IDENTITY")
    owner = User.where(owner: true).first
    baseline = Encounter.create(user_id: owner.id, name: 'Baseline', slug: 'baseline', launch_days_after_sign_up: 0)
    Survey.all.each do |s|
      s.survey_encounters.create(user: s.user, encounter: baseline)
    end
  end

end
