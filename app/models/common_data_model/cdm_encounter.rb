class CdmEncounter < ActiveRecord::Base
  self.table_name = 'cdm_encounter'

  belongs_to :user, foreign_key: 'patid'
end
