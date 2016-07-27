class CreateReportMasterView < ActiveRecord::Migration[4.2]
  def up
    timestamp = '20150327213816'

    execute view_sql(timestamp, :report_master)

  end

  def down
    execute "drop view report_master"
  end
end
