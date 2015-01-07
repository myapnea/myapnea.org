class Topic < ActiveRecord::Base

  # Concerns
  # include Deletable

  # Named Scopes
  scope :current, -> { where( deleted: false ) }
  def destroy
    update_column :deleted, true
  end

  # Model Validation
  validates_presence_of :name, :slug, :user_id, :forum_id
  validates_uniqueness_of :slug, scope: [ :deleted ]
  validates_format_of :slug, with: /\A[a-z][a-z0-9\-]*\Z/

  # Model Relationships
  belongs_to :user
  belongs_to :forum
  # has_many :posts
  def posts
    Forem::Post.limit(10)
  end

  # Topic Methods

  def to_param
    slug
  end

end
