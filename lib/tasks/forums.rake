namespace :forums do

  desc "Migrate Old Forums to New Forums"
  task migrate_old_forums: :environment do

    ActiveRecord::Base.connection.execute("TRUNCATE forums RESTART IDENTITY")
    ActiveRecord::Base.connection.execute("TRUNCATE topics RESTART IDENTITY")
    ActiveRecord::Base.connection.execute("TRUNCATE posts  RESTART IDENTITY")

    Forem::Forum.all.each do |old_forum|
      new_forum = Forum.create(
        name: old_forum.name,
        description: old_forum.description,
        views_count: old_forum.views_count,
        slug: old_forum.slug,
        user_id: User.order(:id).first.id
      )

      old_forum.topics.each do |old_topic|
        new_topic = new_forum.topics.create(
          user_id: old_topic.user_id,
          name: old_topic.subject,
          slug: old_topic.slug,
          locked: old_topic.locked,
          pinned: old_topic.pinned,
          last_post_at: old_topic.last_post_at,
          state: old_topic.state,
          views_count: old_topic.views_count,
          created_at: old_topic.created_at,
          updated_at: old_topic.updated_at,
          migration_flag: '1'
        )

        unless new_topic.new_record?
          old_topic.posts.order( :created_at ).each do |old_post|
            new_topic.posts.create(
              description: old_post.text,
              user_id: old_post.user_id,
              status: old_post.state,
              created_at: old_post.created_at,
              updated_at: old_post.updated_at
            )
          end
        else
          puts "new_topic errors #{new_topic.errors.full_messages}"
          puts "Skipping Topic ID ##{old_topic.id} due to validation errors"
        end
      end
    end

  end

end
