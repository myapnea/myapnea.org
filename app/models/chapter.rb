# frozen_string_literal: true

# Allows users to start new discussion topics on the forum.
class Chapter < ActiveRecord::Base
  REPLIES_PER_PAGE = 20
  attr_accessor :description, :migration_flag

  # Concerns
  include Deletable
  include PgSearch
  multisearchable against: [:title],
                  unless: :deleted?

  # Callbacks
  after_commit :create_first_reply, on: :create

  # Named Scopes
  scope :reply_count, -> { select('chapters.*, COUNT(replies.id) reply_count').joins(:replies).group('chapters.id') }

  # Model Validation
  validates :title, :slug, :user_id, presence: true
  validates :description, presence: true, if: :requires_description?
  validates :slug, uniqueness: { scope: :deleted }
  validates :slug, format: { with: /\A(?!\Anew\Z)[a-z][a-z0-9\-]*\Z/ }

  # Model Relationships
  belongs_to :user
  has_many :replies, -> { order :id }
  has_many :reply_users

  # Model Methods
  def destroy
    super
    update_pg_search_document
    replies.each(&:update_pg_search_document)
  end

  def to_param
    slug_was.to_s
  end

  def editable_by?(current_user)
    user == current_user || current_user.moderator? || current_user.owner?
  end

  def last_page
    ((replies.where(reply_id: nil).count - 1) / REPLIES_PER_PAGE) + 1
  end

  private

  def create_first_reply
    replies.create description: description, user_id: user_id if description.present?
  end

  def requires_description?
    new_record? && migration_flag != '1'
  end
end
