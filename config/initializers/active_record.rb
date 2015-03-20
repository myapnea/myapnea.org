ActiveRecord::Migration.class_eval do
  def view_sql(timestamp,view)
    File.read(Rails.root.join("db/views/#{view}/#{timestamp.to_s}_#{view}.sql"))
  end

  def function_sql(timestamp, function)
    File.read(Rails.root.join("db/functions/#{function}/#{timestamp.to_s}_#{function}.sql"))
  end

end
