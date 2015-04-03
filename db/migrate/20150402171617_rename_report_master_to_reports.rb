class RenameReportMasterToReports < ActiveRecord::Migration
  def up
    timestamp = '20150402171617'

    execute "drop view report_master"
    execute view_sql(timestamp, :reports)
  end

  def down
    timestamp = '20150327213816'

    execute "drop view reports"
    execute view_sql(timestamp, :report_master)
  end
end
