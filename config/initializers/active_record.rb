ActiveRecord::Migration.class_eval do
  def view_sql(timestamp,view)
    File.read(Rails.root.join("db/views/#{view}/#{timestamp.to_s}_#{view}.sql"))
  end
end
