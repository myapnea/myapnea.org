# frozen_string_literal: true

# Defines resources for MyApnea website.
class Admin::Resource < ApplicationRecord
  # Validations
  validates :name, presence: true
  validates :position, presence: true

  # Callback
  mount_uploader :photo, PhotoUploader

  # Concerns
  include Deletable
end
