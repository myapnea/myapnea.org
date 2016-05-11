# frozen_string_literal: true

namespace :surveys do
  desc 'Automatically launch followup encounters for users who have filled out a corresponding baseline survey'
  task launch_followup_encounters: :environment do
    Survey.launch_followup_encounters
  end
end
