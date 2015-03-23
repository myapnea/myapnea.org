namespace :data do

  desc "Export Survey data to CSV for use with PCORNET Common Data Model"
  task export: :environment do

    tmp_folder = File.join('tmp', 'pcornet')

    FileUtils.mkdir_p tmp_folder


    [CdmDemographic, CdmEnrollment, CdmVital, CdmEncounter, CdmProCm].each do |cdm_model|
      export_csv_path = File.join(tmp_folder, "#{cdm_model.table_name}.csv")

      CSV.open(export_csv_path, 'wb') do |csv|
        csv << cdm_model.column_names
        cdm_model.all.each do |db_row|
          csv << db_row.attributes.values
        end
      end
    end
  end
end
