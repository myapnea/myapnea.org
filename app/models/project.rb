# frozen_string_literal: true

# Groups together a series of surveys and a consent.
class Project < ApplicationRecord
  # Constants
  THEMES = [
    %w(Default default),
    %w(Sunset sunset),
    %w(Night night),
    %w(Blue blue),
    %w(Green green),
    %w(Orange orange)
  ]

  # Concerns
  include Deletable
  include Sluggable

  # Scopes
  scope :published, -> { current.where(published: true) }

  # Validations
  validates :name, :access_token, presence: true

  # Relationships
  belongs_to :user

  # Methods
  def destroy
    update slug: nil
    super
  end
end
