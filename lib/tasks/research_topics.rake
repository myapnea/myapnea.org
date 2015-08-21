namespace :research_topics do
  desc "Create research topic forum if one does not exist"
  task create_forum: :environment do
    Forum.create_research_topic_forum
  end
end
