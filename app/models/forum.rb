class Forum < ActiveRecord::Base

  # Concerns
  # include Deletable

  # Named Scopes
  scope :current, -> { where( deleted: false ) }
  def destroy
    update_column :deleted, true
  end

  # Model Validation
  validates_presence_of :name, :slug, :user_id
  validates_uniqueness_of :slug, scope: [ :deleted ]
  validates_format_of :slug, with: /\A[a-z][a-z0-9\-]*\Z/

  # Model Relationships
  belongs_to :user
  has_many :topics, -> { where(deleted: false).order(pinned: :desc, last_post_at: :desc) }

  # Forum Methods

  def to_param
    slug
  end

  def increase_views!(current_user)
    self.update views_count: self.views_count + 1
  end

end
