namespace :data do

  desc "Export Survey data to CSV for use with PCORNET Common Data Model"
  task export: :environment do

    tmp_folder = File.join('tmp', 'pcornet')

    FileUtils.mkdir_p tmp_folder

    users = User.all.order(id: :desc)

    # DEMOGRAPHIC
    export_csv = File.join(tmp_folder, 'demographic.csv')
    CSV.open(export_csv, "wb") do |csv|
      csv << ['PATID', 'BIRTH_DATE', 'RAW_SEX', 'RAW_HISPANIC', 'RAW_RACE']
      users.each do |u|
        csv << [u.pcornet_patid,
                u.pcornet_birth_date,
                u.pcornet_raw_sex,
                u.pcornet_raw_hispanic,
                u.pcornet_raw_race]
      end
    end

    encounterid = 'BASELINE'

    # VITAL
    export_csv = File.join(tmp_folder, 'vital.csv')
    CSV.open(export_csv, "wb") do |csv|
      csv << ['PATID', 'ENCOUNTERID', 'MEASURE_DATE', 'MEASURE_TIME', 'VITAL_SOURCE', 'HT', 'WT']
      users.each do |u|
        csv << [u.pcornet_patid,
                encounterid,
                u.pcornet_ht_measure_date,
                u.pcornet_ht_measure_time,
                u.pcornet_vital_source,
                u.pcornet_ht,
                u.pcornet_wt]
      end
    end

    # PRO_CM
    export_csv = File.join(tmp_folder, 'pro_cm.csv')
    CSV.open(export_csv, "wb") do |csv|
      csv << ['PATID', 'ENCOUNTERID', 'CM_ITEM', 'CM_LOINC', 'CM_DATE', 'CM_TIME', 'CM_RESPONSE', 'CM_METHOD', 'CM_MODE']

      users.each do |u|
        [['PN_0001', '61577-3'],
         ['PN_0002', '61578-1'],
         ['PN_0003', '61582-3'],
         ['PN_0004', '61635-9'],
         ['PN_0005', '61967-6'],
         ['PN_0006', '61878-5'],
         ['PN_0007', '61998-1'],
         ['PN_0008', '75417-6'],
         ['PN_0009', '61758-9']].each do |cm_item, cm_loinc|
          answer = u.send("pcornet_#{cm_item.downcase}")
          if answer and answer.answer_values.pluck(:answer_option_id).first != nil
            cm_date = answer.created_at.strftime("%Y-%m-%d")
            cm_time = answer.created_at.strftime("%H:%M")
            cm_response = "#{answer.answer_values.pluck(:answer_option_id).first}:#{answer.show_value}"
            cm_method = 'EC'
            cm_mode = 'SF'
            csv << [u.pcornet_patid,
                    encounterid,
                    cm_item,
                    cm_loinc,
                    cm_date,
                    cm_time,
                    cm_response,
                    cm_method,
                    cm_mode]
          end
        end
      end
    end


  end

end
