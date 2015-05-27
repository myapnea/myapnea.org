class Highlight < ActiveRecord::Base

  # Concerns
  include Deletable

  mount_uploader :photo, PhotoUploader

  # Model Validation
  validates_presence_of :title


end
