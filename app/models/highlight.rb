class Highlight < ActiveRecord::Base
  # Default Scope
  # Constants
  # Attribute related macros
  # Associations
  # Validations
  validates_presence_of :title

  # Callback
  # Other macros
  mount_uploader :photo, PhotoUploader

  # Concerns
  include Deletable

  # Named scopes
  scope :displayed, -> { current.where(displayed: true) }

  # Methods
end
