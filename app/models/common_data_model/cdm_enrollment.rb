class CdmEnrollment < ActiveRecord::Base
  self.table_name = 'cdm_enrollment'

  belongs_to :user, foreign_key: 'patid'

end
