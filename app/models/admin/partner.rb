# frozen_string_literal: true

# Defines partners for MyApnea website.
class Admin::Partner < ApplicationRecord
  # Constants
  GROUPS = %w(main promotional)

  # Validations
  validates :name, presence: true
  validates :position, presence: true

  # Callback
  mount_uploader :photo, PhotoUploader

  # Concerns
  include Deletable
end
