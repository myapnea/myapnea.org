# frozen_string_literal: true

namespace :broadcasts do
  desc "Prune slugs from deleted broadcasts."
  task prune_slugs: :environment do
    Broadcast.where(deleted: true).update_all slug: nil
  end
end
