namespace :research_topics do
  desc "Migrate old topics and their associated votes over to new system by setting the `deleted` flag."
  task migrate_old: :environment do
    ResearchTopic.destroy_all
    Vote.destroy_all

    seeds = ResearchTopic.load_seeds

    puts "#{seeds[:successful].length + seeds[:with_problems].length} research topics loaded in total."
    puts "#{seeds[:successful].length} research topics loaded successfully."
    puts "#{seeds[:with_problems].length} research topics loaded with problems."
    puts "Messages:\n#{seeds[:messages].join("\n")}"
  end
end
