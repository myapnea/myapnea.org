class Admin::Partner < ActiveRecord::Base
  # Default Scope
  # Constants
  GROUPS = ['main', 'promotional']
  # Attribute related macros
  # Associations
  # Validations
  validates :name, presence: true
  validates :position, presence: true

  # Callback
  # Other macros
  mount_uploader :photo, PhotoUploader

  # Concerns
  include Deletable

  # Named scopes
  # Methods
  def photo_url
    if photo.present?
      photo.url
    else
      'default-user.jpg'
    end
  end
end
