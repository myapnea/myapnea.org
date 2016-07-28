# frozen_string_literal: true

class EngagementResponse < ApplicationRecord
  # Default Scope
  # Constants
  # Attribute related macros
  # Associations
  belongs_to :engagement
  belongs_to :user

  # Validations
  # Callback
  # Other macros
  # Concerns
  include Deletable

  # Scopes
  # Methods
end
