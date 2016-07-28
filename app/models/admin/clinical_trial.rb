# frozen_string_literal: true

class Admin::ClinicalTrial < ApplicationRecord
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

  # Scopes
  # Methods
end
