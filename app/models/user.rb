# frozen_string_literal: true

# Defines the user model, relationships, and permissions. Also provides methods
# to check forum and research consent.
class User < ApplicationRecord
  # Constants
  ORDERS = {
    "posts" => "users.replies_count",
    "posts desc" => "users.replies_count desc",
    "activity desc" => "(CASE WHEN (users.current_sign_in_at IS NULL) THEN users.created_at ELSE users.current_sign_in_at END) desc",
    "activity" => "(CASE WHEN (users.current_sign_in_at IS NULL) THEN users.created_at ELSE users.current_sign_in_at END)",
    "banned desc" => "users.shadow_banned",
    "banned" => "users.shadow_banned desc nulls last",
    "logins desc" => "users.sign_in_count desc",
    "logins" => "users.sign_in_count"
  }
  DEFAULT_ORDER = "(CASE WHEN (users.current_sign_in_at IS NULL) THEN users.created_at ELSE users.current_sign_in_at END) desc"

  # Uploaders
  mount_uploader :photo, PhotoUploader

  # Include default devise modules. Others available are:
  # :confirmable, :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :timeoutable, :lockable, :confirmable

  # Concerns
  include Deletable
  include Forkable
  include Searchable
  include UsernameGenerator
  include Squishable
  squish :full_name

  attr_accessor :consenting

  # Scopes
  scope :include_in_exports_and_reports, -> { where(include_in_exports: true) }
  scope :no_spammer_or_shadow_banned, -> { where(spammer: [false, nil], shadow_banned: [false, nil]) }

  # Validations
  # validates :full_name, presence: true
  validates :full_name, format: { with: /\A.+\s.+\Z/, message: "must be provided to participate in research" }, allow_blank: true, unless: :consenting?
  validates :full_name, format: { with: /\A.+\s.+\Z/, message: "must be provided to participate in research" }, allow_blank: false, if: :consenting?
  validates :username, presence: true
  validates :username, format: {
                         with: /\A[a-zA-Z0-9]+\Z/i,
                         message: "may only contain letters or digits"
                       },
                       exclusion: { in: %w(new edit show create update destroy) },
                       allow_blank: true,
                       uniqueness: { case_sensitive: false }

  # Relationships
  has_many :broadcasts, -> { current }
  has_many :topics, -> { current }
  has_many :topic_users
  has_many :replies, -> { current.left_outer_joins(:broadcast, :topic).where(topics: { id: Topic.current}).or(current.left_outer_joins(:broadcast, :topic).where(broadcasts: { id: Broadcast.published })) }
  has_many :images
  has_many :notifications
  has_many :exports, -> { order id: :desc }, class_name: "Admin::Export"
  has_many :projects, -> { current }
  has_many :subjects
  has_many :subscriptions

  # Methods

  def self.searchable_attributes
    %w(full_name email username)
  end

  def self.profile_review
    where.not(profile_bio: ["", nil]).or(
      where.not(profile_location: ["", nil])
    ).or(
      where.not(photo: ["", nil])
    ).current.where(profile_reviewed: false).order(:id)
  end

  def self.spam_review
    current.where(shadow_banned: true, spammer: [nil, true])
  end

  # Used for account confirmation and password reset emails.
  def first_name_or_username
    first_name.presence || username
  end

  def first_name
    full_name.to_s.split(" ").first
  end

  def profile_present?
    profile_bio.present? || profile_location.present?
  end

  def consent!(project, consented_at: Time.zone.now)
    subject = subjects.where(project: project).first_or_create(consented_at: consented_at)
    subject.find_or_create_remote_subject!
  end

  # Overriding Devise built-in active_for_authentication? method
  def active_for_authentication?
    super && !deleted?
  end

  # Override Devise built-in password reset notification email method
  def send_reset_password_instructions
    return if deleted?
    super
  end

  # Override Devise built-in unlock instructions notification email method
  def send_unlock_instructions
    return if deleted?
    super
  end

  def read_parent!(parent, current_reply_read_id)
    # TODO: Allow blog posts to be read as well...
    return unless parent.is_a?(Topic)
    topic_user = topic_users.where(topic_id: parent.id).first_or_create
    topic_user.update current_reply_read_id: [topic_user.current_reply_read_id.to_i, current_reply_read_id].max,
                      last_reply_read_id: topic_user.current_reply_read_id
  end

  def editable_topics
    if moderator? || admin?
      Topic.current
    else
      topics
    end
  end

  def editable_replies
    if moderator?
      Reply.current
    else
      replies
    end
  end

  def deletable_replies
    if moderator?
      Reply
    else
      replies
    end
  end

  def myapnea_id
    format("MA%06d", id)
  end

  def unread_notifications?
    notifications.where(read: false).present?
  end

  def editable_broadcasts
    if admin?
      Broadcast.current
    else
      broadcasts
    end
  end

  def send_welcome_email_in_background!
    fork_process :send_welcome_email!
  end

  def consenting?
    consenting == "1"
  end

  # Disposable emails are one-off email address website generators.
  def disposable_email?
    DISPOSABLE_EMAILS.include?(email.split("@")[1])
  end

  # Blacklisted emails are email domains flagged for containing a high number of
  # spammers to legitimate users.
  def blacklisted_email?
    BLACKLISTED_EMAILS.include?(email.split("@")[1])
  end

  def send_confirmation_instructions
    return if disposable_email?
    super
  end

  def send_on_create_confirmation_instructions
    return if disposable_email?
    send_welcome_email_in_background!
  end

  def set_as_spammer_and_destroy!
    topics.destroy_all
    Notification.where(reply: replies).destroy_all
    update(spammer: true)
    destroy
  end

  private

  def send_welcome_email!
    UserMailer.welcome(self).deliver_now if EMAILS_ENABLED
  end
end
