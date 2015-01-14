class Topic < ActiveRecord::Base

  STATUS = [['Approved', 'approved'], ['Pending Review', 'pending_review'], ['Marked as Spam', 'spam']]

  attr_accessor :description, :migration_flag

  # Concerns
  # include Deletable

  # Callbacks
  after_save :set_slug
  after_create :create_first_post

  # Named Scopes
  scope :current, -> { where( deleted: false ) }
  scope :viewable_by_user, lambda { |arg| where(hidden: false).where('topics.user_id = ? or topics.status = ?', arg, 'approved') }
  scope :search, lambda { |arg| where('topics.name ~* ? or topics.id in (select posts.topic_id from posts where posts.deleted = ? and posts.description ~* ?)', arg.to_s.split(/\s/).collect{|l| l.to_s.gsub(/[^\w\d%]/, '')}.collect{|l| "(\\m#{l})"}.join("|"), false, arg.to_s.split(/\s/).collect{|l| l.to_s.gsub(/[^\w\d%]/, '')}.collect{|l| "(\\m#{l})"}.join("|") ) }
  def destroy
    update_column :deleted, true
  end

  # Model Validation
  validates_presence_of :name, :user_id, :forum_id
  validates_uniqueness_of :slug, scope: [ :deleted, :forum_id ], allow_blank: true
  validates_format_of :slug, with: /\A([a-z][a-z0-9\-]*)?\Z/
  validates_presence_of :description, if: :requires_description?

  # Model Relationships
  belongs_to :user
  belongs_to :forum
  has_many :posts, -> { order(:created_at) }

  # Topic Methods

  def to_param
    slug
  end

  def editable_by?(current_user)
    # not self.locked? and not self.user.banned? and (self.user == current_user or current_user.has_role?(:moderator))
    (not self.locked? and self.user == current_user) or current_user.has_role?(:moderator)
  end

  def get_or_create_subscription(current_user)
    # Placeholder
  end

  def subscribed?(current_user)
    true
  end

  def increase_views!(current_user)
    self.update views_count: self.views_count + 1
  end

  private

  def create_first_post
    self.posts.create( description: self.description, user_id: self.user_id )
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

  def requires_description?
    self.new_record? and self.migration_flag != '1'
  end

end
