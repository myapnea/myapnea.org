class CreateCdmFunctionsViews < ActiveRecord::Migration[4.2]

  def up
    timestamp = '20150320203722'
    execute function_sql(timestamp, :pcornet_unique_id)
    execute function_sql(timestamp, :pcornet_loinc)

    timestamp = '20150324223004'
    execute view_sql(timestamp, :cdm_demographic)
    execute view_sql(timestamp, :cdm_vital)
    execute view_sql(timestamp, :cdm_enrollment)
    execute view_sql(timestamp, :cdm_encounter)
    execute view_sql(timestamp, :cdm_pro_cm)
  end

  def down
    execute "drop view cdm_demographic"
    execute "drop view cdm_vital"
    execute "drop view cdm_enrollment"
    execute "drop view cdm_pro_cm"
    execute "drop view cdm_encounter"

    execute "drop function pcornet_unique_id(text)"
    execute "drop function pcornet_loinc(text)"
  end
end
