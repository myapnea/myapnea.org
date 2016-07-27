# frozen_string_literal: true

class Admin::Partner < ApplicationRecord
  # Default Scope
  # Constants
  GROUPS = ['main', 'promotional']
  # Attribute related macros
  # Associations
  # Validations
  validates :name, presence: true
  validates :position, presence: true

  # Callback
  # Other macros
  mount_uploader :photo, PhotoUploader

  # Concerns
  include Deletable

  # Named scopes
  # Methods
end
