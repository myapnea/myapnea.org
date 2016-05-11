# frozen_string_literal: true

# A broadcast is a blog post. Blog posts can be edited by community managers and
# set to be published on specific dates.
class Broadcast < ActiveRecord::Base
  # Concerns
  include Deletable

  # Named Scopes
  scope :published, -> { current.where(published: true).where('publish_date <= ?', Time.zone.today) }

  # Model Validation
  validates :title, :slug, :description, :user_id, :publish_date, presence: true
  validates :slug, uniqueness: { scope: :deleted }
  validates :slug, format: { with: /\A(?!\Anew\Z)[a-z][a-z0-9\-]*\Z/ }

  # Model Relationships
  belongs_to :user
  belongs_to :category, class_name: 'Admin::Category'
  has_many :broadcast_comments
  has_many :broadcast_comment_users

  # Model Methods

  def to_param
    slug.to_s
  end

  def url_hash
    {
      year: publish_date.year,
      month: publish_date.strftime('%m'),
      slug: slug
    }
  end

  def editable_by?(current_user)
    current_user.editable_broadcasts.where(id: id).count == 1
  end

  def self.full_text_search(terms)
    where("setweight(to_tsvector(broadcasts.description), 'A') @@ to_tsquery(?)", terms).order(full_text_order(terms))
  end

  def self.full_text_order(terms)
    array = ['ts_rank(to_tsvector(broadcasts.description), to_tsquery(?)) DESC', terms]
    ActiveRecord::Base.send(:sanitize_sql_array, array)
  end
end
