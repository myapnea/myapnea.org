# frozen_string_literal: true

# Allows a user to invite a provider or new member by email.
class Invite < ApplicationRecord
  before_save :check_existing_user
  after_save :generate_token

  # Concerns
  include Forkable

  # Model Validation
  validates :token, uniqueness: true, allow_nil: true

  # Scopes
  scope :members, -> { where for_provider: false }
  scope :providers, -> { where for_provider: true }
  scope :successful, -> { where successful: true }

  # Model Relationships
  belongs_to :user

  def generate_token
    return unless token.blank?
    update token: SecureRandom.hex(12)
  rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid
    retry
  end

  def check_existing_user
    self.recipient_id = User.find_by_email(email).present? ? User.find_by_email(email).id : nil
  end

  def send_provider_invite_in_background!
    fork_process :send_provider_invite
  end

  def send_new_member_invite_in_background!
    fork_process :send_new_member_invite
  end

  private

  def send_provider_invite
    InviteMailer.new_provider_invite(self, user).deliver_now if EMAILS_ENABLED
  end

  def send_new_member_invite
    InviteMailer.new_member_invite(self, user).deliver_now if EMAILS_ENABLED
  end
end
