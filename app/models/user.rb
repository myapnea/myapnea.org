class User < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader

  rolify role_join_table_name: 'roles_users'

  include Authority::UserAbilities
  include Authority::Abilities

  self.authorizer_name = "UserAuthorizer"


  # Include default devise modules. Others available are:
  # :confirmable, :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :lockable

  # Callbacks
  after_create :send_welcome_email

  TYPE = [['Diagnosed With Sleep Apnea', 'patient_diagnosed'],
          ['Concern That I May Have Sleep Apnea', 'patient_at_risk'],
          ['Family Member of an Adult with Sleep Apnea', 'family_member_adult'],
          ['Family Member of a Child with Sleep Apnea', 'family_member_child'],
          ['Provider', 'provider'],
          ['Researcher', 'researcher']]

  # Concerns
  include CommonDataModel, Deletable

  # Named Scopes
  scope :search_by_email, ->(terms) { where("LOWER(#{self.table_name}.email) LIKE ?", terms.to_s.downcase.gsub(/^| |$/, '%')) }
  scope :search, lambda { |arg| where( 'LOWER(first_name) LIKE ? or LOWER(last_name) LIKE ? or LOWER(email) LIKE ?', arg.to_s.downcase.gsub(/^| |$/, '%'), arg.to_s.downcase.gsub(/^| |$/, '%'), arg.to_s.downcase.gsub(/^| |$/, '%') ) }
  scope :providers, -> { where user_type: 'provider' }

  # Model Validation
  validates_presence_of :first_name, :last_name

  with_options unless: :is_provider? do |user|
    user.validates :year_of_birth, presence: true, numericality: {only_integer: true, allow_nil: false, less_than_or_equal_to: -> (user){ Date.today.year - 18 }, greater_than_or_equal_to: -> (user){ 1900 }}
  end

  with_options if: :is_provider? do |user|
    user.validates :provider_name, allow_blank: true, uniqueness: true
    user.validates :slug, allow_blank: true, uniqueness: true, format: { with: /\A[a-z][a-z0-9\-]*[a-z0-9]\Z/ }
  end

  # Model Relationships
  belongs_to :provider, class_name: "User", foreign_key: 'provider_id'
  has_many :answer_sessions, -> { where deleted: false }
  has_many :answers, -> { where deleted: false }
  has_many :votes
  has_one :social_profile, -> { where deleted: false }
  has_many :notifications, -> { where deleted: false }
  has_many :research_topics, -> { where deleted: false }
  has_many :forums, -> { where deleted: false }
  has_many :topics, -> { where deleted: false }
  has_many :posts, -> { where deleted: false }
  has_many :approved_posts, -> { where deleted: false, status: 'approved' }, through: :posts, source: :topic
  has_many :subscriptions
  has_many :users, class_name: "User", foreign_key: "provider_id"

  # Overriding Devise built-in active_for_authentication? method
  def active_for_authentication?
    super and not self.deleted?
  end

  # Alias to be deprecated
  def is_provider?
    self.provider?
  end

  def provider?
    self.user_type == 'provider'
  end

  def all_topics
    if self.has_role? :moderator
      Topic.current
    else
      self.topics.where(locked: false)
    end
  end

  def viewable_topics
    if self.has_role? :moderator
      Topic.current
    else
      Topic.viewable_by_user(self.id)
    end
  end

  def all_posts
    if self.has_role? :moderator
      Post.current.with_unlocked_topic
    else
      self.posts.with_unlocked_topic
    end
  end

  # All comments created in the last day, or over the weekend if it is Monday
  # Ex: On Monday, returns tasks created since Friday morning (Time.now - 3.day)
  # Ex: On Tuesday, returns tasks created since Monday morning (Time.now - 1.day)
  def digest_posts
    # Comment.digest_visible.where( topic_id: self.subscribed_topics.pluck(:id) ).where("created_at > ?", (Time.now.monday? ? Time.now.midnight - 3.day : Time.now.midnight - 1.day))
    # Post.digest_visible.where( topic_id: self.subscribed_topics.pluck(:id) ).where("created_at > ?", (Time.now.monday? ? Time.now.midnight - 3.day : Time.now.midnight - 1.day))
    Post.current.where(status: 'approved').where("created_at > ?", (Time.now.monday? ? Time.now.midnight - 3.day : Time.now.midnight - 1.day))
  end

  def smart_forum
    forum_id = self.posts.group_by{|p| p.forum.id}.collect{|forum_id, posts| [forum_id, posts.count]}.sort{|a,b| b[1] <=> a[1]}.collect{|a| a[0]}.first
    forum = Forum.current.find_by_id(forum_id)
    forum ? forum : Forum.current.order(:position).first
  end

  def name
    "#{first_name} #{last_name}"
  end

  def self.scoped_users(email=nil, role=nil)
    users = current

    users = users.search_by_email(email) if email.present?
    users = users.with_role(role) if role.present?

    users
  end

  def photo_url
    if social_profile
      social_profile.photo_url
    else
      'default-user.jpg'
    end
  end

  # Should change to this
  # def photo_url
  #   if photo.present?
  #     photo.url
  #   else
  #     'default-user.jpg'
  #   end
  # end

  def my_photo_url
    if social_profile and social_profile.photo
      social_profile.photo.url
    else
      photo_url
    end
  end

  def forum_name
    if social_profile
      social_profile.public_nickname
    else
      SocialProfile.get_anonymous_name(email)
    end
  end

  def can_post_links?
    self.has_role? :moderator or self.has_role? :owner
  end

  def to_s
    email
  end

  def revoke_consent
    update_attribute :accepted_consent_at, nil
    update_attribute :accepted_privacy_policy_at, nil
  end

  def created_social_profile?
    self.social_profile.present? and self.social_profile.name.present?
  end

  def signed_consent?
    # Local Consent Storage
    self.accepted_consent_at.present?
    # OODT Consent Storage
    #self.oodt_status
  end

  def accepted_privacy_policy?
    self.accepted_privacy_policy_at.present?

  end

  def accepted_terms_conditions?
    self.accepted_terms_conditions_at.present?
  end

  def ready_for_research?
    accepted_privacy_policy? and signed_consent?
  end

  def todays_votes
    votes.select{|vote| vote.updated_at.today? and vote.rating != 0 and vote.research_topic_id.present?}
  end

  def available_votes_percent
    (todays_votes.length.to_f / vote_quota) * 100.0
  end

  def incomplete_surveys
    QuestionFlow.incomplete(self)
  end

  def complete_surveys
    QuestionFlow.complete(self)
  end

  def unstarted_surveys
    QuestionFlow.unstarted(self)
  end

  def not_complete_surveys
    self.incomplete_surveys + self.unstarted_surveys
  end

  def smart_surveys
    self.incomplete_surveys + self.unstarted_surveys + self.complete_surveys
  end

  def research_topics_with_vote
    ResearchTopic.voted_by(self)
  end

  def submitted_research_topics
    ResearchTopic.created_by(self)
  end

  def has_no_started_surveys?
    incomplete_surveys.blank? and complete_surveys.blank?
  end

  def share_research_topics?
    social_profile.present? and social_profile.show_publicly?
  end

  def number_votes_remaining
    vote_quota - todays_votes.length
  end

  def has_votes_remaining?(rating = 1)

    (todays_votes.length < vote_quota) or (rating < 1)
  end

  def answer_for(answer_session, question)
    Answer.current.where(answer_session_id: answer_session.id, question_id: question.id).order("updated_at desc").includes(answer_values: :answer_template).limit(1).first
  end

  ## Provider Methods

  def get_welcome_message
    if welcome_message.present?
      welcome_message
    else
      "Welcome to my provider page!"
    end
  end


  private

  def send_welcome_email
    # UserMailer.welcome(self).deliver if Rails.env.production?
  end
end
