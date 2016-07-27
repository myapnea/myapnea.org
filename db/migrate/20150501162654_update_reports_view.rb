class UpdateReportsView < ActiveRecord::Migration[4.2]
  def up
    timestamp = '20150501162654'

    execute "drop view reports"

    execute view_sql(timestamp, :reports)
  end

  def down
    timestamp = '20150402171617'

    execute "drop view reports"

    execute view_sql(timestamp, :reports)
  end
end
