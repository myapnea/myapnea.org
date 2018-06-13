# frozen_string_literal: true

# Defines team members for team page.
class Admin::TeamMember < ApplicationRecord
  # Uploaders
  mount_uploader :photo, PhotoUploader

  # Concerns
  include Deletable

  # Validations
  validates :name, presence: true
end
