class Admin::ResearchArticle < ActiveRecord::Base
  # Default Scope
  # Constants
  # Attribute related macros
  # Associations
  # Validations
  # Callback
  # Other macros
  mount_uploader :photo, PhotoUploader

  # Concerns
  include Deletable

  # Named scopes
  # Methods
  def to_param
    slug
  end

  def self.find_by_param(input)
    find_by_slug(input)
  end
end
