class Topic < ActiveRecord::Base

  STATUS = [['Approved', 'approved'], ['Pending Review', 'pending_review'], ['Marked as Spam', 'spam'], ['Hidden', 'hidden']]

  POSTS_PER_PAGE = 20

  attr_accessor :description, :migration_flag

  # Concerns
  include Deletable
  include Groupable

  # Callbacks
  before_validation :set_slug
  after_create :create_first_post

  # Named Scopes
  scope :viewable_by_user, lambda { |arg| where('topics.status = ? or topics.user_id = ?', 'approved', arg) }
  scope :search, lambda { |arg| where('topics.name ~* ? or topics.id in (select posts.topic_id from posts where posts.deleted = ? and posts.description ~* ?)', arg.to_s.split(/\s/).collect{|l| l.to_s.gsub(/[^\w\d%]/, '')}.collect{|l| "(\\m#{l})"}.join("|"), false, arg.to_s.split(/\s/).collect{|l| l.to_s.gsub(/[^\w\d%]/, '')}.collect{|l| "(\\m#{l})"}.join("|") ) }
  scope :user_active, lambda { |arg| where('topics.id IN (select posts.topic_id from posts where posts.user_id IN (?) and posts.status = ? and posts.deleted = ?)', arg, 'approved', false ) }
  scope :pending_review, -> { where('topics.status = ? or topics.id IN (select posts.topic_id from posts where posts.deleted = ? and posts.status = ?)', 'pending_review', false, 'pending_review') }
  scope :not_research, -> { where('topics.id NOT IN (select research_topics.topic_id from research_topics where research_topics.topic_id IS NOT NULL)')}

  # Model Validation
  validates_presence_of :name, :user_id, :forum_id, message: "The title cannot be blank."
  validates_uniqueness_of :slug, scope: [ :deleted, :forum_id ], allow_blank: true, message: "This topic title already exists in this forum."
  validates_format_of :slug, with: /\A(?!\Anew\Z)[a-z][a-z0-9\-]*\Z/, message: "The format of the slug is invalid."
  validates_presence_of :description, if: :requires_description?

  # Model Relationships
  belongs_to :user
  belongs_to :forum
  has_one :research_topic # For research topic functionality
  has_many :posts, -> { order(:created_at) }
  has_many :subscriptions
  has_many :subscribers, -> { current.where(emails_enabled: true).where(subscriptions: { subscribed: true }) }, through: :subscriptions, source: :user

  # Topic Methods

  def to_param
    slug
  end

  def hidden?
    self.status == 'hidden'
  end

  def editable_by?(current_user)
    (not self.locked? and self.user == current_user) or current_user.moderator?
  end

  def deletable_by?(current_user)
    self.user == current_user or current_user.owner?
  end

  def get_or_create_subscription(current_user)
    current_user.subscriptions.where( topic_id: self.id ).first_or_create
  end

  def set_subscription!(notify, current_user)
    get_or_create_subscription(current_user).update subscribed: notify
  end

  def subscribed?(current_user)
    subscription = current_user.subscriptions.where( topic_id: self.id ).first
    subscription && subscription.subscribed? ? true : false
  end

  def subscription_type(current_user)
    subscription = current_user.subscriptions.where( topic_id: self.id ).first
    if subscription and subscription.subscribed == true
      'subscribed'
    elsif subscription and subscription.subscribed == false
      'muted'
    # elsif current_user.auto_subscribe?
    #   'auto-subscribed'
    else
      'auto-muted'
    end
  end

  def increase_views!(current_user)
    self.update views_count: self.views_count + 1
  end

  def set_last_post_at!
    if last_post = self.posts.where(status: ['approved', 'pending_review']).last
      self.update last_post_at: last_post.created_at
    else
      self.update last_post_at: nil
    end
  end

  def visible_posts
    self.posts.current.visible_for_user
  end

  def last_visible_post
    self.visible_posts.includes(:user).order(:created_at).last
  end

  def has_posts_pending_review?
    self.posts.where(status: 'pending_review').count > 0
  end

  private

  def create_first_post
    if self.description.present?
      self.posts.create( description: self.description, user_id: self.user_id )
      self.get_or_create_subscription( self.user )
    end

  end

  def set_slug
    if self.new_record?
      self.slug = self.name.parameterize
      self.slug = 't' + self.slug unless self.slug.first.to_s.downcase.in?(('a'..'z'))
      if (Topic.current.where(forum_id: self.forum_id, slug: self.slug).count > 0) or self.slug == 'new'
        self.slug += "-#{SecureRandom.hex(8)}"
      end
    end
  end

  def requires_description?
    self.new_record? and self.migration_flag != '1' and !self.forum.for_research_topics?
  end

end
