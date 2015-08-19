class User < ActiveRecord::Base

  # Uploaders
  mount_uploader :photo, PhotoUploader

  #  For recent updates to consent/privacy policy/etc
  RECENT_UPDATE_DATE = "2015-06-24"

  # Include default devise modules. Others available are:
  # :confirmable, :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :lockable

  # Callbacks
  after_create :set_forum_name, :send_welcome_email, :check_for_token, :update_location

  # Mappings
  TYPES = [['Adult who has been diagnosed with sleep apnea', 'adult_diagnosed'],
          ['Adult who is at-risk of sleep apnea', 'adult_at_risk'],
          ['Caregiver of adult diagnosed with or at-risk of sleep apnea', 'caregiver_adult'],
          ['Caregiver of child(ren) diagnosed with or at-risk of sleep apnea', 'caregiver_child'],
          ['Professional care provider', 'provider'],
          ['Research professional', 'researcher']]

  # Concerns
  include CommonDataModel, Deletable

  attr_accessor :user_is_updating

  # Named Scopes
  scope :search, lambda { |arg| where( 'LOWER(first_name) LIKE ? or LOWER(last_name) LIKE ? or LOWER(email) LIKE ?', arg.to_s.downcase.gsub(/^| |$/, '%'), arg.to_s.downcase.gsub(/^| |$/, '%'), arg.to_s.downcase.gsub(/^| |$/, '%') ) }
  scope :providers, -> { current.where(provider: true) }
  scope :include_in_exports_and_reports, -> { where(include_in_exports: true) }

  # Model Validation
  validates_presence_of :first_name, :last_name

  validates :forum_name, allow_blank: true, uniqueness: true, format: { with: /\A[a-zA-Z0-9]*\Z/i }, unless: :update_by_user?
  validates :forum_name, allow_blank: false, uniqueness: true, format: { with: /\A[a-zA-Z0-9]+\Z/i }, if: :update_by_user?

  with_options unless: :provider? do |user|
    user.validates :over_eighteen, inclusion: { in: [true], message: "You must be over 18 years of age to sign up" }, allow_nil: true
    #user.validates :year_of_birth, presence: true, numericality: {only_integer: true, allow_nil: false, less_than_or_equal_to: -> (user){ Date.today.year - 18 }, greater_than_or_equal_to: -> (user){ 1900 }}
  end

  with_options if: :provider? do |user|
    user.validates :provider_name, allow_blank: true, uniqueness: true
    user.validates :slug, allow_blank: true, uniqueness: true, format: { with: /\A[a-z][a-z0-9\-]*[a-z0-9]\Z/i }
  end

  # Model Relationships
  belongs_to :my_provider, class_name: "User", foreign_key: 'provider_id'
  has_many :answer_sessions, -> { where deleted: false }
  has_many :answers, -> { where deleted: false }
  has_many :votes, -> { where deleted: false }
  has_one :social_profile, -> { where deleted: false }
  has_many :notifications, -> { where deleted: false }
  has_many :research_topics, -> { where deleted: false }
  has_many :forums, -> { where deleted: false }
  has_many :topics, -> { where deleted: false }
  has_many :posts, -> { where deleted: false }
  has_many :subscriptions
  has_many :users, class_name: "User", foreign_key: "provider_id"
  has_many :invites
  has_many :children, -> { where(deleted: false).order("age desc", :first_name) }
  has_many :encounters, -> { where deleted: false }

  ## Builder

  has_many :questions, -> { where deleted: false }
  has_many :answer_templates, -> { where deleted: false }

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

  def is_academic?
    self.researcher? or self.provider?
  end

  def has_user_type?
    self.adult_diagnosed? or self.adult_at_risk? or self.caregiver_child? or self.caregiver_adult? or self.provider? or self.researcher?
  end

  def user_type_names
    User::TYPES.collect do |label, user_type|
      label if self[user_type]
    end.compact
  end

  def user_types
    User::TYPES.collect do |label, user_type|
      user_type if self[user_type]
    end.compact
  end

  def viewable_topics
    if self.moderator? or self.owner?
      Topic.current
    else
      Topic.viewable_by_user(self.id)
    end
  end

  def editable_topics
    if self.moderator? or self.owner?
      Topic.current
    else
      self.topics.where(locked: false)
    end
  end

  def deletable_topics
    if self.owner?
      Topic.current
    else
      self.topics
    end
  end

  def editable_posts
    if self.moderator? or self.owner?
      Post.current.with_unlocked_topic
    else
      self.posts.with_unlocked_topic
    end
  end

  def deletable_posts
    if self.owner?
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

  def name
    "#{first_name} #{last_name}"
  end

  def name_and_email
    "#{first_name} #{last_name} <#{email}>"
  end

  def photo_url
    if photo.present?
      photo.url
    else
      'default-user.jpg'
    end
  end

  def api_photo_url
    if photo.size > 0
      "#{ENV['website_url']}#{photo.url}"
    else
      nil
    end
  end

  def can_post_links?
    self.moderator? or self.owner?
  end

  def revoke_consent!
    self.update_column :accepted_terms_of_access_at, nil
    self.update_column :accepted_consent_at, nil
    self.update_column :accepted_privacy_policy_at, nil
  end

  def signed_consent?
    self.accepted_consent_at.present?
  end

  def accepted_privacy_policy?
    self.accepted_privacy_policy_at.present?
  end

  def accepted_consent?
    self.accepted_consent_at.present?
  end

  def accepted_terms_conditions?
    self.accepted_terms_conditions_at.present?
  end

  def ready_for_research?
    if self.provider? or is_only_researcher?
      accepted_privacy_policy? and accepted_terms_of_access?
      # accepted_privacy_policy? and (accepted_terms_of_access? or signed_consent?) # is this complicating things? Should they just be asked to sign the ToA?
    else
      accepted_privacy_policy? and signed_consent?
    end
  end

  def accepted_terms_of_access?
    self.accepted_terms_of_access_at.present?
  end

  # Should not compare against RECENT_UPDATE_DATE if it is in the future
  def accepted_most_recent_update?
    (self.accepted_update_at.present? and (self.accepted_update_at > Date.parse(RECENT_UPDATE_DATE).at_noon)) or (Date.parse(RECENT_UPDATE_DATE).at_noon > Time.now )
  end

  # User Types
  def update_user_types(user_types)
    update user_types
    assign_default_surveys

  end

  # Surveys
  def get_baseline_survey_answer_session(survey)
    self.answer_sessions.where(encounter: 'baseline', survey_id: survey.id, child_id: nil).first_or_create
  end

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

  def completed_demographic_survey?
    self.answer_sessions.where(survey_id: Survey.find_by_slug('about-me').id).where(locked:true).present?
  end

  # Can Build Surveys
  def editable_surveys
    Survey.current.where(user_id: self.id).where.not(slug: nil)
  end

  # Research Topics
  def my_research_topics
    self.research_topics
  end

  def highlighted_research_topic
    ResearchTopic.highlighted(self).first
  end

  def seeded_research_topic
    ResearchTopic.seeded(self).first
  end

  # Voting
  def cast_vote_for?(research_topic)
    votes.current.where(research_topic_id: research_topic.id).count > 0
  end

  def endorsed?(research_topic)
    votes.current.where(research_topic_id: research_topic.id, rating: 1).count > 0
  end

  def opposed?(research_topic)
    votes.current.where(research_topic_id: research_topic.id, rating: 0).count > 0
  end

  def vote_count
    votes.current.where(rating: [0, 1]).count
  end

  def experienced_voter?
    vote_count >= ResearchTopic::INTRO_LENGTH
  end

  def novice_voter?
    vote_count < ResearchTopic::INTRO_LENGTH and vote_count > 0

  end

  def no_votes_user?
    vote_count == 0
  end

  ## Provider Methods

  def send_provider_informational_email!
    unless Rails.env.test?
      pid = Process.fork
      if pid.nil? then
        # In child
        UserMailer.welcome_provider(self).deliver_later if Rails.env.production? and self.provider?
        Kernel.exit!
      else
        # In parent
        Process.detach(pid)
      end
    end
  end

  def accepts_consent!
    current_time = Time.zone.now
    self.update accepted_consent_at: current_time, accepted_update_at: current_time
  end

  def accepts_terms_of_access!
    current_time = Time.zone.now
    self.update accepted_terms_of_access_at: current_time, accepted_update_at: current_time
  end

  private

  # This happens when any user updates changes from dashboard
  def update_by_user?
    self.user_is_updating == '1'
  end

  def set_forum_name
    if self.forum_name.blank?
      self.update forum_name: SocialProfile.generate_forum_name(self.email, Time.now.usec.to_s)
    end
  end

  def send_welcome_email
    unless Rails.env.test?
      pid = Process.fork
      if pid.nil? then
        # In child
        UserMailer.welcome(self).deliver_later if Rails.env.production?
        Kernel.exit!
      else
        # In parent
        Process.detach(pid)
      end
    end
  end

  def check_for_token
    if self.invite_token.present?
      Invite.find_by_token(self.invite_token).update(successful: true)
    end
  end

  def update_location
    Map.update_user_location(self)
  end

  def assign_default_surveys
    remove_out_of_range_answer_sessions!
    User::TYPES.each do |label, user_type|
      if self[user_type]
        Survey.current.viewable.non_pediatric.joins(:survey_user_types).merge(SurveyUserType.current.where(user_type: user_type)).each do |survey|
          survey.encounters.where(launch_days_after_sign_up: 0).each do |encounter|
            survey.launch_single(self, encounter.slug)
          end
        end
      end
    end
  end

  def remove_out_of_range_answer_sessions!
    self.answer_sessions.where(child_id: nil).each do |answer_session|
      if answer_session.answers.count == 0 and not answer_session.available_for_user_types?(self.user_types)
        answer_session.destroy
      end
    end
  end

end
