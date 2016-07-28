# frozen_string_literal: true

class Admin::TeamMember < ApplicationRecord
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

  # Scopes
  # Methods
end
