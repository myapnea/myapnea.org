# frozen_string_literal: true

class Admin::ResearchArticle < ActiveRecord::Base
  # Default Scope
  # Constants
  # Attribute related macros
  # Associations
  belongs_to :research_topic

  # Validations
  validates :slug, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :content, presence: true
  validates :author, presence: true

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
