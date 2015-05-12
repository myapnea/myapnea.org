namespace :research_topics do
  desc "Migrate old topics and their associated votes over to new system by setting the `deleted` flag."
  task migrate_old: :environment do
    ResearchTopic.destroy_all
    Vote.destroy_all
  end
end
