# frozen_string_literal: true

class Comment < ApplicationRecord
  # Default Scope
  # Constants
  # Attribute related macros
  # Associations
  belongs_to :post
  belongs_to :user

  # Validations
  validates :post_id, presence: true
  validates :content, presence: true

  # Callback
  # Other macros
  # Concerns
  include Deletable

  # Named scopes
  # Methods
end
