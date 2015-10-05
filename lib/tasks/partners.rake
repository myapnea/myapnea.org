require 'yaml'

namespace :admin do
  desc "Create team members"
  task create_partners: :environment do
    data_file = YAML.load_file(Rails.root.join('lib', 'data', 'content', 'partners.yml'))
    data_file['partners'].each do |partner_attributes|
      partner = Admin::Partner.create(partner_attributes)
      puts "Created: " + partner.name
    end
  end
end
