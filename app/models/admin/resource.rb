# frozen_string_literal: true

# Defines resources for MyApnea website.
class Admin::Resource < ApplicationRecord
  # Concerns
  include Deletable
  include Sluggable

  # Validations
  validates :name, presence: true
  validates :position, presence: true

  # Callback
  mount_uploader :photo, PhotoUploader

  # Methods
  def destroy
    update slug: nil
    super
  end
end
