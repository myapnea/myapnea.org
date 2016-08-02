# frozen_string_literal: true

namespace :forum do
  # TODO: Remove migrate task.
  desc 'Migrate forum to new structure'
  task migrate: :environment do
    ActiveRecord::Base.connection.execute('TRUNCATE chapters RESTART IDENTITY;')
    ActiveRecord::Base.connection.execute('TRUNCATE replies RESTART IDENTITY;')

    Topic.not_research.order(:id).each do |topic|
      chapter = Chapter.create(
        migration_flag: '1',
        title: topic.name,
        slug: topic.slug,
        user_id: topic.user_id,
        pinned: false,
        last_reply_at: topic.posts.last.created_at,
        view_count: topic.views_count,
        deleted: (['hidden', 'spam'].include?(topic.status) ? true : topic.deleted),
        created_at: topic.created_at,
        updated_at: topic.updated_at
      )
      topic.posts.order(:id).each do |post|
        reply = chapter.replies.create(
          user_id: post.user_id,
          description: post.description,
          reply_id: nil,
          deleted: (['hidden', 'spam'].include?(post.status) ? true : post.deleted),
          created_at: post.created_at,
          updated_at: post.updated_at
        )
        post.comments.order(:id).each do |comment|
          chapter.replies.create(
            user_id: comment.user_id,
            description: comment.content,
            reply_id: reply.id,
            deleted: comment.deleted,
            created_at: comment.created_at,
            updated_at: comment.updated_at
          )
        end
      end
      chapter.replies.order(:created_at).last
    end
  end

  desc 'Export Forum and Research Topics to CSVs'
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

    # TODO: Remove Research topics table
    CSV.open('tmp/research_topics.csv', 'wb') do |csv|
      csv << %w(ResearchTopicID Type UserForumName Text Replies Views)
      ResearchTopic.current.approved.each do |research_topic|
        topic = research_topic.topic
        next unless topic
        location = [topic.id]
        csv << location + ['ResearchTopic', topic.user.forum_name, topic.name.downcase.tr("\n", ' '), topic.posts.current.where(status: %w(approved pending_review)).count, topic.views_count]
        topic.posts.current.where(status: %w(approved pending_review)).each do |post|
          csv << location + ['ResearchTopic Comment', post.user.forum_name, post.description.downcase.tr("\n", ' ')]
        end
      end
    end
    puts 'Created tmp/research_topics.csv'
  end
end
