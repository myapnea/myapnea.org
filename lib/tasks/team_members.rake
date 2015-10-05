require 'yaml'

namespace :admin do
  desc "Create team members"
  task create_team: :environment do
    data_file = YAML.load_file(Rails.root.join('lib', 'data', 'content', 'team.yml'))
    data_file['team_members'].each do |team_member_attributes|
      member = Admin::TeamMember.create(team_member_attributes)
      puts "Created: " + member.name
    end
  end
end
