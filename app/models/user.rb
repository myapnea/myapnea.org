class User < ActiveRecord::Base

  mount_uploader :photo, PhotoUploader

  include Authority::UserAbilities
  include Authority::Abilities

  self.authorizer_name = "UserAuthorizer"

  #  For recent updates to consent/privacy policy/etc
  RECENT_UPDATE_DATE = "2015-06-01"

  # Include default devise modules. Others available are:
  # :confirmable, :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :lockable

  # Callbacks
  after_create :set_forum_name, :send_welcome_email, :check_for_token

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

  attr_accessor :user_is_updating

  # Named Scopes
  scope :search_by_email, ->(terms) { where("LOWER(#{self.table_name}.email) LIKE ?", terms.to_s.downcase.gsub(/^| |$/, '%')) }
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

  def user_types
    user_types = [('Adult diagnosed with sleep apnea' if self.adult_diagnosed?), ('Adult at-risk of sleep apnea' if self.adult_at_risk?), ('Caregiver of adult(s) with sleep apnea' if self.caregiver_adult?), ('Caregiver of child(ren) with sleep apnea' if self.caregiver_child?), ('Professional care provider' if self.provider?), ('Researcher' if self.researcher?) ].reject(&:blank?)
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

  def smart_forum
    forum_id = self.posts.group_by{|p| p.forum.id}.collect{|forum_id, posts| [forum_id, posts.count]}.sort{|a,b| b[1] <=> a[1]}.collect{|a| a[0]}.first
    forum = Forum.current.find_by_id(forum_id)
    forum ? forum : Forum.current.order(:position).first
  end

  def name
    "#{first_name} #{last_name}"
  end

  def name_and_email
    "#{first_name} #{last_name} <#{email}>"
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
    # elsif social_profile
    #   social_profile.photo_url
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

  def can_post_links?
    self.moderator? or self.owner?
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


  # Reports
  def answer_present?(params = {})
    Report.where({ user: self[:id] }.merge(params)).count > 0
  end

  def answer_value(params = {})
    result_rows = Report.where({ user: self[:id] }.merge(params))

    answer_option_rows = result_rows.where(data_type: 'answer_option_id')
    if answer_option_rows.count == 1
      answer_option_rows.pluck(:value).first
    elsif answer_option_rows.count > 1
      answer_option_rows.pluck(:value)
    else
      result_rows.pluck(:value).first
    end
  end

  def answer_text(params={})
    result_rows = Report.where({ user: self[:id] }.merge(params))

    # One answer value:
    if result_rows.count == 1
      result_row = result_rows.first

      ## Answer option
      ## Non-answer option
      result_row.data_type == 'answer_option_id' ? result_row.answer_option_text : result_row.value

    elsif result_rows.count > 1
      if result_rows.where(allow_multiple: true).count == 0
        # Two answer values, no multiple allowed
        if result_rows.where(data_type: 'answer_option_id').pluck(:value).map(&:to_i).include? result_rows.pluck(:target_answer_option).compact.first
          ## Non-answer option with target_answer_option selected
          result_rows.where("target_answer_option is not null").pluck(:value).first
        else
          ## target_answer_option not selected
          result_rows.where(data_type: 'answer_option_id').pluck(:answer_option_text).first
        end
      else
        # Multiple Values Allowed:
        ## Write-in with target_answer_option selected

        all_ao_values = result_rows.where(data_type: 'answer_option_id').pluck(:value)
        ignore_values = result_rows.pluck(:target_answer_option).compact



        write_in_result_rows = result_rows.where("target_answer_option is not null").where(target_answer_option: all_ao_values)
        ao_result_rows = result_rows.where(data_type: 'answer_option_id')
        ao_result_rows = ao_result_rows.where.not(value: ignore_values.map(&:to_s)) if ignore_values

        ## Just answer option answer
        write_in_result_rows.pluck(:value) + ao_result_rows.pluck(:answer_option_text)
      end
    end
  end

  def answer_formatted_text(params={})
    answer = answer_text(params)

    if answer.kind_of?(Array)
      answer.delete_if{|x| x.blank? }.join(", ")
    else
      answer
    end

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

  def get_welcome_message
    if welcome_message.present?
      welcome_message
    end
  end

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
