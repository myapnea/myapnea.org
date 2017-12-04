# frozen_string_literal: true

# Allows broadcasts to be grouped by category.
class Admin::Category < ApplicationRecord
  # Concerns
  include Deletable
  include Sluggable

  # Validations
  validates :name, :slug, presence: true

  # Relationships
  has_many :broadcasts, -> { current }

  # Methods
  def destroy
    update slug: nil
    super
  end
end
