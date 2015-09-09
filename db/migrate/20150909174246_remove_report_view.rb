class RemoveReportView < ActiveRecord::Migration
  def up
    execute "drop view reports"
  end

  def down
    timestamp = '20150909151513'
    execute view_sql(timestamp, :reports)
  end
end
