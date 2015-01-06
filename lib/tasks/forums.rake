namespace :forums do

  desc "Migrate Old Forums to New Forums"
  task migrate_old_forums: :environment do

    ActiveRecord::Base.connection.execute("TRUNCATE forums")

    Forem::Forum.all.each do |f|
      Forum.create(
        name: f.name,
        description: f.description,
        views_count: f.views_count,
        slug: f.slug,
        user_id: User.order(:id).first.id
      )
    end

  end

end
