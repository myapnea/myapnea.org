# frozen_string_literal: true

# Provides methods to allow users to co-enroll with other participating sites
module Coenrollment
  extend ActiveSupport::Concern

  included do
    after_save :set_heh_outgoing_token

    validates :outgoing_heh_token, :incoming_heh_token, uniqueness: true, allow_nil: true
  end

  def heh_referral_url
    "https://www.health-eheartstudy.org/?rfk=#{ENV['heh_referral_key']}&id=#{outgoing_heh_token}"
  end

  def set_heh_outgoing_token
    return unless outgoing_heh_token.blank?
    update outgoing_heh_token: SecureRandom.hex(12)
  rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid
    retry
  end
end
