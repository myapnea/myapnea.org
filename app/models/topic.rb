class Topic < ActiveRecord::Base

  attr_accessor :description

  # Concerns
  # include Deletable

  # Callbacks
  after_save :set_slug
  after_create :create_first_post

  # Named Scopes
  scope :current, -> { where( deleted: false ) }
  def destroy
    update_column :deleted, true
  end

  # Model Validation
  validates_presence_of :name, :user_id, :forum_id
  validates_uniqueness_of :slug, scope: [ :deleted, :forum_id ], allow_blank: true
  validates_format_of :slug, with: /\A([a-z][a-z0-9\-]*)?\Z/
  validates_presence_of :description, if: :new_record?

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

  private

  def create_first_post
    # self.posts.create( description: self.description, user_id: self.user_id )
    # self.get_or_create_subscription( self.user )
  end

  def set_slug
    if self.slug.blank?
      self.slug = self.name.parameterize
      if self.valid?
        self.save
      else
        self.slug += "-#{SecureRandom.hex(8)}"
        self.save
      end
    end
  end

end
