# frozen_string_literal: true

# TODO: Remove in v19
namespace :exports do
  desc "Reset counter_cache for models."
  task update_file_sizes: :environment do
    Admin::Export.find_each do |export|
      export.update file_size: export.zipped_file.size
    end
  end
end
# END TODO
