# frozen_string_literal: true

# TODO: Deprecated in v17.0.0

# Groups together surveys.
class Encounter < ApplicationRecord
  # Concerns
  include Deletable

  # Model Validation
  validates_presence_of :name, :slug, :launch_days_after_sign_up, :user_id
  validates_uniqueness_of :slug, scope: [ :deleted ]
  validates_format_of :slug, with: /\A(?!\Anew\Z)[a-z0-9][a-z0-9\-]*\Z/
  validates_numericality_of :launch_days_after_sign_up, greater_than_or_equal_to: 0, less_than_or_equal_to: 5000

  # Model Relationships
  belongs_to :user
  has_many :survey_encounters
  has_many :surveys, -> { where deleted: false }, through: :survey_encounters

  # Model Methods

  def to_param
    slug
  end

  def self.find_by_param(input)
    find_by(slug: input)
  end

  def editable_by?(u)
    u.admin?
  end
end
