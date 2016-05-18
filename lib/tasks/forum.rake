# frozen_string_literal: true

namespace :forum do
  desc 'Migrate forum to new structure'
  task migrate: :environment do
    ActiveRecord::Base.connection.execute('TRUNCATE chapters RESTART IDENTITY;')
    ActiveRecord::Base.connection.execute('TRUNCATE replies RESTART IDENTITY;')

    Topic.not_research.order(:id).each do |topic|
      first_post = topic.posts.order(:id).first
      chapter = Chapter.create(
        title: topic.name,
        slug: topic.slug,
        description: first_post.description,
        user_id: topic.user_id,
        pinned: false,
        last_reply_at: topic.posts.last.created_at,
        view_count: topic.views_count,
        deleted: (['hidden', 'spam'].include?(topic.status) ? true : topic.deleted),
        created_at: topic.created_at,
        updated_at: topic.updated_at
      )
      topic.posts.order(:id)[1..-1].each do |post|
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
end
