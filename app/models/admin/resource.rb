# frozen_string_literal: true

# Defines resources for MyApnea website.
class Admin::Resource < ApplicationRecord
  # Uploaders
  mount_uploader :attachment, PDFUploader
  mount_uploader :photo, PhotoUploader

  # Concerns
  include Deletable
  include Sluggable

  # Validations
  validates :name, presence: true
  validates :position, presence: true

  # Methods
  def destroy
    update slug: nil
    super
  end
end
