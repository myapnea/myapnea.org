class Encounter < ActiveRecord::Base

  # Concerns
  include Deletable

  # Model Validation
  validates_presence_of :name, :slug, :launch_days_after_sign_up
  validates_uniqueness_of :slug, scope: [ :survey_id, :deleted ]
  validates_format_of :slug, with: /\A(?!\Anew\Z)[a-z0-9][a-z0-9\-]*\Z/

  # Model Relationships
  belongs_to :user
  belongs_to :survey

  # Model Methods

  def to_param
    slug
  end

  def self.find_by_param(input)
    find_by_slug(input)
  end

end
