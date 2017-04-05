# frozen_string_literal: true

namespace :forum do
  desc 'Export Forum to CSV'
  task export: :environment do
    CSV.open('tmp/forum.csv', 'wb') do |csv|
      csv << %w(TopicID Type UserForumName Text Replies Views)
      Topic.current.each do |topic|
        location = [topic.id]
        csv << location + ['Topic', topic.user.forum_name, topic.title.downcase.tr("\n", ' '), topic.replies.current.count, topic.view_count]
        topic.replies.current.each do |reply|
          csv << location + ['Reply', reply.user.forum_name, reply.description.downcase.tr("\n", ' ')]
        end
      end
    end
    puts 'Created tmp/forum.csv'
  end
end
