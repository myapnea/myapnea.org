class CdmVital < ActiveRecord::Base
  self.table_name = 'cdm_vital'

  belongs_to :user, foreign_key: 'patid'

end
