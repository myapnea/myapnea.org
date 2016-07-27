# frozen_string_literal: true

class Invite < ApplicationRecord
  after_commit    :generate_token, on: :create
  before_save     :check_existing_user

  validates_uniqueness_of :token, allow_nil: true

  scope :members, -> { where(for_provider: false) }
  scope :providers, -> { where(for_provider: true) }
  scope :successful, -> { where(successful: true) }

  belongs_to :user

  def generate_token
    begin
      self.update_column :token, Digest::SHA1.hexdigest([self.user_id, Time.zone.now, rand].join)
    rescue
    end
  end

  def check_existing_user
    self.recipient_id = User.find_by_email(self.email).present? ? User.find_by_email(self.email).id : nil
  end
end
