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

  # Mappings
  TYPE = [['Diagnosed With Sleep Apnea', 'adult_diagnosed'],
          ['Concern That I May Have Sleep Apnea', 'adult_at_risk'],
          ['Family Member of an Adult with Sleep Apnea', 'caregiver_adult'],
          ['Family Member of a Child with Sleep Apnea', 'caregiver_child'],
          ['Provider', 'provider'],
          ['Researcher', 'researcher']]

  DEFAULT_SURVEYS = {
    adult_diagnosed: ['about-me', 'additional-information-about-me', 'about-my-family', 'my-health-conditions', 'my-sleep-pattern', 'my-sleep-quality', 'my-sleep-apnea', 'my-sleep-apnea-treatment', 'my-quality-of-life', 'my-interest-in-research'],
    adult_at_risk: ['about-me', 'additional-information-about-me', 'about-my-family', 'my-health-conditions', 'my-sleep-pattern', 'my-sleep-quality', 'my-risk-profile', 'my-quality-of-life', 'my-interest-in-research'],
    caregiver_adult: ['about-me', 'additional-information-about-me', 'about-my-family', 'my-interest-in-research'],
    caregiver_child: ['about-me', 'additional-information-about-me', 'about-my-family', 'my-interest-in-research']
  }

  # Concerns
  include CommonDataModel, Deletable

  # Named Scopes
  scope :search_by_email, ->(terms) { where("LOWER(#{self.table_name}.email) LIKE ?", terms.to_s.downcase.gsub(/^| |$/, '%')) }
  scope :search, lambda { |arg| where( 'LOWER(first_name) LIKE ? or LOWER(last_name) LIKE ? or LOWER(email) LIKE ?', arg.to_s.downcase.gsub(/^| |$/, '%'), arg.to_s.downcase.gsub(/^| |$/, '%'), arg.to_s.downcase.gsub(/^| |$/, '%') ) }
  scope :providers, -> { current.where(provider: true) }

  # Model Validation
  validates_presence_of :first_name, :last_name

  with_options unless: :is_provider? do |user|
    user.validates :over_eighteen, inclusion: { in: [true], message: "You must be over 18 years of age to sign up" }, allow_nil: true
    #user.validates :year_of_birth, presence: true, numericality: {only_integer: true, allow_nil: false, less_than_or_equal_to: -> (user){ Date.today.year - 18 }, greater_than_or_equal_to: -> (user){ 1900 }}
  end

  with_options if: :is_provider? do |user|
    user.validates :provider_name, allow_blank: true, uniqueness: true
    user.validates :slug, allow_blank: true, uniqueness: true, format: { with: /\A[a-z][a-z0-9\-]*[a-z0-9]\Z/i }
  end

  # Model Relationships
  belongs_to :my_provider, class_name: "User", foreign_key: 'provider_id'
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

  # CDM
  has_one :cdm_demographic, foreign_key: 'patid'
  has_one :cdm_enrollment, foreign_key: 'patid'
  has_many :cdm_encounters, foreign_key: 'patid'
  has_many :cdm_vitals, foreign_key: 'patid'
  has_many :cdm_pro_cms, foreign_key: 'patid'

  # Reports
  has_many :reports

  # Overriding Devise built-in active_for_authentication? method
  def active_for_authentication?
    super and not self.deleted?
  end

  # Alias to be deprecated
  def is_provider?
    self.provider?
  end

  def is_only_provider?
    self.provider? and !self.is_nonacademic?
  end

  def is_only_researcher?
    self.researcher? and !self.is_nonacademic?
  end

  def is_only_academic?
    (self.researcher? or self.provider?) and !self.is_nonacademic?
  end

  def is_nonacademic?
    self.adult_diagnosed? or self.adult_at_risk? or self.caregiver_child? or self.caregiver_adult?
  end

  def has_user_type?
    self.adult_diagnosed? or self.adult_at_risk? or self.caregiver_child? or self.caregiver_adult? or self.provider? or self.researcher?
  end

  def user_types
    user_types = [('Adult diagnosed with sleep apnea' if self.adult_diagnosed?), ('Adult at-risk of sleep apnea' if self.adult_at_risk?), ('Caregiver of adult(s) with sleep apnea' if self.caregiver_adult?), ('Caregiver of child(ren) with sleep apnea' if self.caregiver_child?), ('Professional care provider' if self.provider?), ('Researcher' if self.researcher?) ].reject(&:blank?)
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
    if photo.present?
      photo.url
    elsif social_profile
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

  def revoke_consent!
    update_attribute :accepted_terms_of_access_at, nil
    update_attribute :accepted_consent_at, nil
    update_attribute :accepted_privacy_policy_at, nil
  end

  def created_social_profile?
    self.social_profile.present? and self.social_profile.name.present?
  end

  def signed_consent?
    self.accepted_consent_at.present?
  end

  def accepted_privacy_policy?
    self.accepted_privacy_policy_at.present?
  end

  def accepted_terms_conditions?
    self.accepted_terms_conditions_at.present?
  end

  def ready_for_research?
    if is_nonacademic?
      accepted_privacy_policy? and signed_consent?
    else
      accepted_privacy_policy? and (accepted_terms_of_access? or signed_consent?)
    end
  end

  def accepted_terms_of_access?
    self.accepted_terms_of_access_at.present?
  end

  def this_weeks_votes
    self.votes.where("votes.updated_at >= ? ", Time.now.beginning_of_week(:sunday)).where.not(rating: '0', research_topic_id: nil)
  end

  def todays_votes
    votes.select{|vote| vote.updated_at.today? and vote.rating != 0 and vote.research_topic_id.present?}
  end

  def available_votes_percent
    (this_weeks_votes.length.to_f / vote_quota) * 100.0
  end

  # User Types
  def update_user_types(user_types)
    update user_types
    assign_default_surveys

  end

  # Surveys
  def assigned_surveys
    Survey.viewable.joins(:answer_sessions).where(answer_sessions: {user_id: self.id}).order("answer_sessions.locked asc, answer_sessions.position asc, surveys.default_position asc, answer_sessions.encounter")
  end

  def completed_surveys
    Survey.viewable.joins(:answer_sessions).where(answer_sessions: {user_id: self.id, locked: true}).order("answer_sessions.locked asc, answer_sessions.position asc, answer_sessions.encounter")
  end

  def incomplete_surveys
    Survey.viewable.joins(:answer_sessions).where(answer_sessions: {user_id: self.id, locked: [false, nil]}).order("answer_sessions.locked asc, answer_sessions.position asc, answer_sessions.encounter")
  end

  def visible_surveys
    is_only_academic? ? Survey.viewable : assigned_surveys
  end

  def completed_assigned_surveys?
    assigned_surveys == completed_surveys
  end

  def next_survey(survey)
    incomplete_surveys.where("surveys.id != ?", survey.id).first
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

  def answer_for(answer_session, question)
    Answer.current.where(answer_session_id: answer_session.id, question_id: question.id).order("updated_at desc").includes(answer_values: :answer_template).limit(1).first
  end

  def unlock_survey!(slug, encounter)
    as = answer_sessions.joins(:survey).where(surveys: {slug: slug}, encounter: encounter).first
    if as.present?
      as.unlock
    else
      nil
    end
  end


  # Voting
  def number_votes_remaining
    vote_quota - this_weeks_votes.length
  end

  def has_votes_remaining?(rating = 1)

    (this_weeks_votes.length < vote_quota) or (rating < 1)
  end

  def positive_votes
    self.votes.where.not(research_topic_id: nil).where(rating: '1')
  end


  ## Provider Methods

  def get_welcome_message
    if welcome_message.present?
      welcome_message
    end
  end


  private

  def send_welcome_email
    UserMailer.welcome(self).deliver if Rails.env.production? and !self.provider?
  end

  def assign_default_surveys
    DEFAULT_SURVEYS.each do |user_type, survey_list|
      if self[user_type]
        return survey_list.map do |survey_slug|
          survey = Survey.find_by_slug(survey_slug)
          if survey
            survey.launch_single(self, "baseline")
            survey
          else
            logger.error "Survey #{survey_slug} could not be assigned to user #{self.email} - Survey could not be found."
            nil
          end
        end
      end
    end
  end
end
