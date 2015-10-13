class Admin::TeamMember < ActiveRecord::Base
  # Default Scope
  # Constants
  GROUPS = ['steering', 'internal', 'patient']
  # Attribute related macros
  # Associations
  # Validations
  # Callback
  # Other macros
  mount_uploader :photo, PhotoUploader

  # Concerns
  include Deletable

  # Named scopes
  # Methods
end
