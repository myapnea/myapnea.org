class EngagementResponse < ActiveRecord::Base
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

  # Named scopes
  # Methods
end
