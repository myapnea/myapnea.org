class CdmProCm < ActiveRecord::Base
  self.table_name = 'cdm_pro_cm'

  belongs_to :user, foreign_key: 'patid'

end
