# frozen_string_literal: true

# Defines the user model, relationships, and permissions. Also provides methods
# to check forum and research consent.
class User < ApplicationRecord
  # Uploaders
  mount_uploader :photo, PhotoUploader

  #  For recent updates to consent/privacy policy/etc
  RECENT_UPDATE_DATE = '2015-09-11'

  # Include default devise modules. Others available are:
  # :confirmable, :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :lockable

  # Callbacks
  after_commit :set_forum_name, :send_welcome_email_in_background!, :check_for_token, :update_location, on: :create

  # Mappings
  TYPES = [
    ['Adult who has been diagnosed with sleep apnea', 'adult_diagnosed'],
    ['Adult who is at-risk of sleep apnea', 'adult_at_risk'],
    ['Caregiver of adult diagnosed with or at-risk of sleep apnea', 'caregiver_adult'],
    ['Caregiver of child(ren) diagnosed with or at-risk of sleep apnea', 'caregiver_child'],
    ['Professional care provider', 'provider'],
    ['Research professional', 'researcher']
  ]

  # Concerns
  include Deletable, Coenrollment, Forkable

  attr_accessor :user_is_updating

  # Scopes
  scope :search, lambda { |arg| where( 'LOWER(first_name) LIKE ? or LOWER(last_name) LIKE ? or LOWER(email) LIKE ?', arg.to_s.downcase.gsub(/^| |$/, '%'), arg.to_s.downcase.gsub(/^| |$/, '%'), arg.to_s.downcase.gsub(/^| |$/, '%') ) }
  scope :providers, -> { current.where(provider: true) }
  scope :providers_with_profiles, -> { providers.where.not(slug: [nil,''], provider_name: [nil,'']) }
  scope :include_in_exports_and_reports, -> { where(include_in_exports: true) }
  scope :reply_count, -> { select('users.*, COALESCE(COUNT(replies.id), 0) reply_count').joins('LEFT OUTER JOIN replies ON replies.user_id = users.id and replies.deleted IS FALSE and replies.chapter_id IN (SELECT chapters.id FROM chapters WHERE chapters.deleted IS FALSE)').group('users.id') }

  # Model Validation
  validates :first_name, :last_name, presence: true

  validates :forum_name, allow_blank: true, uniqueness: { case_sensitive: false }, format: { with: /\A[a-zA-Z0-9]*\Z/i }, unless: :update_by_user?
  validates :forum_name, allow_blank: false, uniqueness: { case_sensitive: false }, format: { with: /\A[a-zA-Z0-9]+\Z/i }, if: :update_by_user?

  with_options unless: :provider? do |user|
    user.validates :over_eighteen, inclusion: { in: [true], message: "You must be over 18 years of age to sign up" }, allow_nil: true
  end

  with_options if: :provider? do |user|
    user.validates :provider_name, allow_blank: true, uniqueness: { case_sensitive: false }
    user.validates :slug, allow_blank: true, uniqueness: { case_sensitive: false }, format: { with: /\A[a-z][a-z0-9\-]*[a-z0-9]\Z/i }
  end

  # Model Relationships
  belongs_to :my_provider, class_name: 'User', foreign_key: 'provider_id'
  has_many :answer_sessions, -> { where deleted: false }
  has_many :answers
  has_many :broadcasts, -> { current }
  has_many :broadcast_comments
  has_many :chapters, -> { current }
  has_many :chapter_users
  has_many :replies, -> { current.joins(:chapter).merge(Chapter.current) }
  has_one :social_profile, -> { where deleted: false }
  has_many :images
  has_many :notifications
  has_many :users, class_name: 'User', foreign_key: 'provider_id'
  has_many :invites
  has_many :children, -> { where(deleted: false).order('age desc', :first_name) }
  has_many :encounters, -> { where deleted: false }
  has_many :exports, -> { order id: :desc }, class_name: 'Admin::Export'

  ## Builder

  has_many :questions, -> { where deleted: false }
  has_many :answer_templates, -> { where deleted: false }

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

  def read_chapter!(chapter, current_reply_read_id)
    chapter_user = chapter_users.where(chapter_id: chapter.id).first_or_create
    chapter_user.update current_reply_read_id: [chapter_user.current_reply_read_id.to_i, current_reply_read_id].max,
                        last_reply_read_id: chapter_user.current_reply_read_id
  end

  def is_only_researcher?
    researcher? && !is_nonacademic?
  end

  def is_only_academic?
    (researcher? || provider?) && !is_nonacademic?
  end

  def is_nonacademic?
    adult_diagnosed? || adult_at_risk? || caregiver_child? || caregiver_adult?
  end

  def has_user_type?
    adult_diagnosed? || adult_at_risk? || caregiver_child? || caregiver_adult? || provider? || researcher?
  end

  def user_type_names
    User::TYPES.collect do |label, user_type|
      label if self[user_type]
    end.compact
  end

  def user_types
    User::TYPES.collect do |_label, user_type|
      user_type if self[user_type]
    end.compact
  end

  def editable_chapters
    if moderator? || owner?
      Chapter.current
    else
      chapters
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
    'MA%06d' % id
  end

  def name
    "#{first_name} #{last_name}"
  end

  def name_and_email
    "#{first_name} #{last_name} <#{email}>"
  end

  def unread_notifications?
    notifications.where(read: false).present?
  end

  def revoke_consent!
    update_column :accepted_terms_of_access_at, nil
    update_column :accepted_consent_at, nil
    update_column :accepted_privacy_policy_at, nil
  end

  def signed_consent?
    accepted_consent_at.present?
  end

  def accepted_privacy_policy?
    accepted_privacy_policy_at.present?
  end

  def accepted_consent?
    accepted_consent_at.present?
  end

  def accepted_terms_conditions?
    accepted_terms_conditions_at.present?
  end

  def ready_for_research?
    if provider? || is_only_researcher?
      accepted_privacy_policy? and accepted_terms_of_access?
      # accepted_privacy_policy? and (accepted_terms_of_access? or signed_consent?) # is this complicating things? Should they just be asked to sign the ToA?
    else
      accepted_privacy_policy? and signed_consent?
    end
  end

  def accepted_terms_of_access?
    accepted_terms_of_access_at.present?
  end

  # Should not compare against RECENT_UPDATE_DATE if it is in the future
  def accepted_most_recent_update?
    (accepted_update_at.present? && accepted_update_at > Date.parse(RECENT_UPDATE_DATE).at_noon) ||
      (Date.parse(RECENT_UPDATE_DATE).at_noon > Time.zone.now && !Rails.env.test?)
  end

  # User Types
  def update_user_types(user_types)
    update user_types
    assign_default_surveys
  end

  # Surveys
  def get_baseline_survey_answer_session(survey)
    answer_sessions.no_child.where(encounter: 'baseline', survey_id: survey.id).first_or_create
  end

  def completed_answer_sessions
    answer_sessions.no_child.where(locked: true).joins(:survey).merge(Survey.current.viewable)
  end

  def incomplete_answer_sessions
    answer_sessions.no_child.where(locked: false).joins(:survey).merge(Survey.current.viewable)
  end

  def completed_assigned_answer_sessions?
    answer_sessions.no_child.where(locked: false).joins(:survey).merge(Survey.current.viewable).count == 0
  end

  def next_answer_session(answer_session)
    incomplete_answer_sessions.where.not(id: answer_session.id).first if answer_session
  end

  # Child Surveys
  def completed_child_answer_sessions(child_input)
    answer_sessions.where(child_id: child_input, locked: true).joins(:survey).merge(Survey.current.viewable)
  end

  def incomplete_child_answer_sessions(child_input)
    answer_sessions.where(child_id: child_input, locked: false).joins(:survey).merge(Survey.current.viewable)
  end

  def completed_child_assigned_answer_sessions?(child_input)
    answer_sessions.where(child_id: child_input, locked: false).joins(:survey).merge(Survey.current.viewable).count == 0
  end

  def next_child_answer_session(answer_session)
    if answer_session && answer_session.child.present?
      answer_sessions.where(child_id: answer_session.child_id, locked: false).where.not(id: answer_session.id).joins(:survey).merge(Survey.current.viewable).first
    end
  end

  def completed_demographic_survey?
    answer_sessions.where(survey_id: Survey.find_by_slug('about-me').id).where(locked:true).present?
  end

  # Can Build Surveys
  def editable_surveys
    Survey.with_editor(id).order(:name_en)
  end

  def accepts_consent!
    current_time = Time.zone.now
    update accepted_consent_at: current_time, accepted_update_at: current_time
  end

  def accepts_terms_of_access!
    current_time = Time.zone.now
    update accepted_terms_of_access_at: current_time, accepted_update_at: current_time
  end

  def editable_broadcasts
    if owner?
      Broadcast.current
    else
      broadcasts
    end
  end

  def editable_broadcast_comments
    if moderator?
      BroadcastComment.current
    else
      broadcast_comments
    end
  end

  def send_provider_informational_email_in_background!
    fork_process :send_provider_informational_email!
  end

  def send_welcome_email_in_background!
    fork_process :send_welcome_email!
  end

  private

  def send_provider_informational_email!
    return unless EMAILS_ENABLED
    UserMailer.welcome_provider(self).deliver_now if provider?
  end

  # This happens when any user updates changes from dashboard
  def update_by_user?
    user_is_updating == '1'
  end

  def set_forum_name
    return if forum_name.present?
    update forum_name: SocialProfile.generate_forum_name(email, Time.zone.now.usec.to_s)
  end

  def send_welcome_email!
    UserMailer.welcome(self).deliver_now if EMAILS_ENABLED
  end

  def check_for_token
    Invite.find_by_token(invite_token).update(successful: true) if invite_token.present?
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
    answer_sessions.no_child.each do |answer_session|
      if answer_session.answers.count == 0 && !answer_session.available_for_user_types?(user_types)
        answer_session.delete
      end
    end
  end
end
