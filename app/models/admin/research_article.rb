class Admin::ResearchArticle < ActiveRecord::Base
  # Default Scope
  # Constants
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
