namespace :forums do

  desc "Migrate Old Forums to New Forums"
  task migrate_old_forums: :environment do

    ActiveRecord::Base.connection.execute("TRUNCATE forums RESTART IDENTITY")
    ActiveRecord::Base.connection.execute("TRUNCATE topics RESTART IDENTITY")

    Forem::Forum.all.each do |old_forum|
      new_forum = Forum.create(
        name: old_forum.name,
        description: old_forum.description,
        views_count: old_forum.views_count,
        slug: old_forum.slug,
        user_id: User.order(:id).first.id
      )

      old_forum.topics.each do |t|
        new_forum.topics.create(
          user_id: t.user_id,
          name: t.subject,
          slug: t.slug,
          locked: t.locked,
          pinned: t.pinned,
          last_post_at: t.last_post_at,
          state: t.state,
          views_count: t.views_count,
          created_at: t.created_at,
          updated_at: t.updated_at
        )
      end
    end

  end

end
