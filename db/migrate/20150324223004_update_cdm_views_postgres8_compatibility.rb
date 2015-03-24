class UpdateCdmViewsPostgres8Compatibility < ActiveRecord::Migration
  def up
    timestamp = 20150324223004

    execute "drop view cdm_demographic"
    execute "drop view cdm_vital"
    execute "drop view cdm_enrollment"
    execute "drop view cdm_pro_cm"
    execute "drop view cdm_encounter"

    execute view_sql(timestamp, :cdm_demographic)
    execute view_sql(timestamp, :cdm_vital)
    execute view_sql(timestamp, :cdm_enrollment)
    execute view_sql(timestamp, :cdm_encounter)
    execute view_sql(timestamp, :cdm_pro_cm)
  end

  def down
    timestamp = '20150320203722'

    execute "drop view cdm_demographic"
    execute "drop view cdm_vital"
    execute "drop view cdm_enrollment"
    execute "drop view cdm_pro_cm"
    execute "drop view cdm_encounter"

    execute view_sql(timestamp, :cdm_demographic)
    execute view_sql(timestamp, :cdm_vital)
    execute view_sql(timestamp, :cdm_enrollment)
    execute view_sql(timestamp, :cdm_encounter)
    execute view_sql(timestamp, :cdm_pro_cm)
  end
end
