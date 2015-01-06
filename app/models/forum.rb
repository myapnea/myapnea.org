class Forum < ActiveRecord::Base

  # Concerns
  # include Deletable

  # Named Scopes
  scope :current, -> { where( deleted: false ) }
  def destroy
    update_column :deleted, true
  end
  # Placeholders
  def topics
    Forum.none
  end


  # Model Validation
  validates_presence_of :name, :slug, :user_id
  validates_uniqueness_of :slug, scope: [ :deleted ]
  validates_format_of :slug, with: /\A[a-z][a-z0-9\-]*\Z/

  # Model Relationships
  belongs_to :user
  # Placeholders
  def topics
    Forum.none
  end

  # Forum Methods

  def to_param
    slug
  end

end
