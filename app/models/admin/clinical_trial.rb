class Admin::ClinicalTrial < ActiveRecord::Base
  # Default Scope
  # Constants
  # Attribute related macros
  # Associations
  # Validations
  validates :title, presence: true
  validates :eligibility, presence: true
  validates :description, presence: true

  # Callback
  # Other macros
  # Concerns
  include Deletable

  # Named scopes
  # Methods
end
