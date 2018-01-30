# frozen_string_literal: true

# Defines the user model, relationships, and permissions. Also provides methods
# to check forum and research consent.
class User < ApplicationRecord
  # Uploaders
  mount_uploader :photo, PhotoUploader

  # Include default devise modules. Others available are:
  # :confirmable, :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :timeoutable, :lockable

  # Concerns
  include Deletable
  include Forkable
  include UsernameGenerator
  include Squishable
  squish :full_name

  attr_accessor :consenting

  # Scopes
  scope :search, lambda { |arg| where( "LOWER(full_name) LIKE ? or LOWER(email) LIKE ?", arg.to_s.downcase.gsub(/^| |$/, "%"), arg.to_s.downcase.gsub(/^| |$/, "%") ) }
  scope :include_in_exports_and_reports, -> { where(include_in_exports: true) }
  scope :reply_count, -> { select("users.*, COALESCE(COUNT(replies.id), 0) reply_count").joins("LEFT OUTER JOIN replies ON replies.user_id = users.id and replies.deleted IS FALSE and replies.topic_id IN (SELECT topics.id FROM topics WHERE topics.deleted IS FALSE)").group("users.id") }
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
  has_many :replies, -> { current.joins(:topic).merge(Topic.current) }
  has_many :images
  has_many :notifications
  has_many :exports, -> { order id: :desc }, class_name: "Admin::Export"
  has_many :projects, -> { current }
  has_many :subjects
  has_many :subscriptions

  # Methods

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

  private

  def send_welcome_email!
    UserMailer.welcome(self).deliver_now if EMAILS_ENABLED
  end
end
