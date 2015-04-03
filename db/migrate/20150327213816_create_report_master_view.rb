class CreateReportMasterView < ActiveRecord::Migration
  def up
    timestamp = '20150327213816'

    execute view_sql(timestamp, :report_master)

  end

  def down
    execute "drop view report_master"
  end
end
