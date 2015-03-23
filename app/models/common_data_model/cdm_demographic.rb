class CdmDemographic < ActiveRecord::Base
  self.table_name = 'cdm_demographic'

  belongs_to :user, foreign_key: 'patid'
end
