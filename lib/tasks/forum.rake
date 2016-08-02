# frozen_string_literal: true

namespace :forum do
  desc 'Export Forum to CSV'
  task export: :environment do
    CSV.open('tmp/forum.csv', 'wb') do |csv|
      csv << %w(TopicID Type UserForumName Text Replies Views)
      Chapter.current.each do |chapter|
        location = [chapter.id]
        csv << location + ['Topic', chapter.user.forum_name, chapter.title.downcase.tr("\n", ' '), chapter.replies.current.count, chapter.view_count]
        chapter.replies.current.each do |reply|
          csv << location + ['Reply', reply.user.forum_name, reply.description.downcase.tr("\n", ' ')]
        end
      end
    end
    puts 'Created tmp/forum.csv'
  end
end
