# frozen_string_literal: true

# TODO: Remove in v17.0.0

namespace :replies do
  desc 'Merge broadcast comments and topic replies'
  task merge: :environment do
    reply_map = { 'broadcast_comment_id_' => nil }
    puts "Reply.count: #{Reply.count}"
    puts "BroadcastComment.count: #{BroadcastComment.count}"
    puts "Reply.where.not(broadcast_id: nil).count: #{Reply.where.not(broadcast_id: nil).count}"
    BroadcastComment.order(:created_at).each do |broadcast_comment|
      puts "Couldn't find parent of BroadcastComment ##{broadcast_comment.id}" if !broadcast_comment.broadcast_comment_id.nil? && reply_map["broadcast_comment_id_#{broadcast_comment.broadcast_comment_id}"].nil?
      reply = broadcast_comment.broadcast.replies.create(
        user_id: broadcast_comment.user_id,
        description: broadcast_comment.description,
        reply_id: reply_map["broadcast_comment_id_#{broadcast_comment.broadcast_comment_id}"],
        deleted: broadcast_comment.deleted,
        created_at: broadcast_comment.created_at,
        updated_at: broadcast_comment.updated_at,
        topic_id: nil
      )
      reply_map["broadcast_comment_id_#{broadcast_comment.id}"] = reply.id
      broadcast_comment.broadcast_comment_users.each do |broadcast_comment_user|
        reply.reply_users.create(
          broadcast_id: broadcast_comment_user.broadcast_id,
          user_id: broadcast_comment_user.user_id,
          vote: broadcast_comment_user.vote,
          created_at: broadcast_comment_user.created_at,
          updated_at: broadcast_comment_user.updated_at,
          topic_id: nil
        )
      end
    end
    puts "Reply.count: #{Reply.count}"
    puts "Reply.where.not(broadcast_id: nil).count: #{Reply.where.not(broadcast_id: nil).count}"
  end

  desc 'Remove notifications related to Broadcast Comments'
  task clear_broadcast_comment_notifications: :environment do
    Notification.where.not(broadcast_comment_id: nil).delete_all
  end
end
