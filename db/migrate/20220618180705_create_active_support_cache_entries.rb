class CreateActiveSupportCacheEntries < ActiveRecord::Migration[6.1]
  def up
    ActiveSupport::Cache::DatabaseStore::Migration.migrate(:up)
  end

  def down
    ActiveSupport::Cache::DatabaseStore::Migration.migrate(:down)
  end
end
