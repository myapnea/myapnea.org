# frozen_string_literal: true

# A broadcast is a blog post. Blog posts can be edited by community managers and
# set to be published on specific dates.
class Broadcast < ActiveRecord::Base
  # Concerns
  include Deletable
  include PgSearch
  multisearchable against: [:title, :short_description, :keywords, :description],
                  unless: :deleted?

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
  def destroy
    super
    update_pg_search_document
    broadcast_comments.each(&:update_pg_search_document)
  end

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
    array = ['ts_rank(to_tsvector(broadcasts.description), to_tsquery(?)) DESC, id desc', terms]
    ActiveRecord::Base.send(:sanitize_sql_array, array)
  end

  def self.compute_ranges(description_array, terms)
    cleaned_array = description_array.collect { |t| t.gsub(/[^\w]/, '').to_s.downcase }
    indices = cleaned_array.each_index.select { |i| cleaned_array[i].in?(terms) }
    @ranges = []
    indices.each do |index|
      @ranges << [[index - 4, 0].max, [index + 4, cleaned_array.count].min]
    end
    @ranges = merge_overlapping_ranges(@ranges)
    @ranges = [[0, 9]] if @ranges.empty?
    @ranges
  end

  def self.ranges_overlap?(a, b)
    a.last >= b.first
  end

  def self.merge_ranges(a, b)
    [[a.first, b.first].min, [a.last, b.last].max]
  end

  def self.merge_overlapping_ranges(ranges)
    ranges.sort_by(&:first).inject([]) do |inner_ranges, range|
      if !inner_ranges.empty? && ranges_overlap?(inner_ranges.last, range)
        inner_ranges[0...-1] + [merge_ranges(inner_ranges.last, range)]
      else
        inner_ranges + [range]
      end
    end
  end
end
