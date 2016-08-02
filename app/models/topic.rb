# frozen_string_literal: true

class Topic < ApplicationRecord
  STATUS = [['Approved', 'approved'], ['Pending Review', 'pending_review'], ['Marked as Spam', 'spam'], ['Hidden', 'hidden']]
  POSTS_PER_PAGE = 20

  attr_accessor :description, :migration_flag

  # Concerns
  include Deletable
  include Groupable

  # Callbacks
  before_validation :set_slug, on: :create
  after_commit :create_first_post, on: :create

  # Scopes
  scope :viewable_by_user, lambda { |arg| where('topics.status = ? or topics.user_id = ?', 'approved', arg) }
  scope :search, lambda { |arg| where('topics.name ~* ? or topics.id in (select posts.topic_id from posts where posts.deleted = ? and posts.description ~* ?)', arg.to_s.split(/\s/).collect{|l| l.to_s.gsub(/[^\w\d%]/, '')}.collect{|l| "(\\m#{l})"}.join("|"), false, arg.to_s.split(/\s/).collect{|l| l.to_s.gsub(/[^\w\d%]/, '')}.collect{|l| "(\\m#{l})"}.join("|") ) }
  scope :user_active, lambda { |arg| where('topics.id IN (select posts.topic_id from posts where posts.user_id IN (?) and posts.status = ? and posts.deleted = ?)', arg, 'approved', false ) }
  scope :pending_review, -> { where('topics.status = ? or topics.id IN (select posts.topic_id from posts where posts.deleted = ? and posts.status = ?)', 'pending_review', false, 'pending_review') }

  # Model Validation
  validates :user_id, presence: true
  validates :name, presence: { message: 'The title cannot be blank' }
  validates :description, presence: true, if: :requires_description?
  validates :slug, uniqueness: { scope: :deleted, message: 'This topic title already exists on the forum' }, allow_blank: true
  validates :slug, format: { with: /\A(?!\Anew\Z)[a-z][a-z0-9\-]*\Z/, message: 'The format of the slug is invalid.' }

  # Model Relationships
  belongs_to :user
  belongs_to :forum
  has_many :posts, -> { order(:created_at) }
  has_many :subscriptions
  has_many :subscribers, -> { current.where(emails_enabled: true).where(subscriptions: { subscribed: true }) }, through: :subscriptions, source: :user

  # Topic Methods

  def to_param
    slug
  end

  def hidden?
    status == 'hidden'
  end

  def editable_by?(current_user)
    (!locked? && user == current_user) || current_user.moderator?
  end

  def deletable_by?(current_user)
    user == current_user || current_user.owner?
  end

  def get_or_create_subscription(current_user)
    current_user.subscriptions.where(topic_id: id).first_or_create
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
    if description.present?
      posts.create description: description, user_id: user_id
      get_or_create_subscription(user)
    end
  end

  def set_slug
    if new_record?
      self.slug = name.parameterize
      self.slug = 't' + slug unless slug.first.to_s.downcase.in?(('a'..'z'))
      if slug == 'new' || (Topic.current.where(forum_id: forum_id, slug: slug).count > 0)
        self.slug = "#{slug}-#{SecureRandom.hex(8)}"
      end
    end
  end

  def requires_description?
    new_record? && migration_flag != '1'
  end
end
