# Research topic belongs to forum topic

class ResearchTopic < ActiveRecord::Base
  # Concerns
  include Deletable
  include Authority::Abilities

  # Accessors
  attr_writer :description, :text

  # Associations
  belongs_to :user
  belongs_to :topic
  has_many :votes, -> { where(deleted: false) }

  # Constants
  PROGRESS = [:proposed, :accepted, :ongoing_research, :complete]

  # Callbacks
  after_create :create_associated_topic

  # Named Scopes
  scope :approved, lambda { current.joins(:topic).where(topics: {status: 'approved'})}
  scope :pending_review, lambda { current.joins(:topic).where(topics: {status: 'pending_review'})}
  scope :most_voted, lambda { current.select("research_topics.*, count(votes.id) as vote_count").joins("left outer join votes on votes.research_topic_id = research_topics.id and votes.deleted = 'f'").group("research_topics.id").order("vote_count desc") }
  scope :least_voted, lambda { current.select("research_topics.*, count(votes.id) as vote_count").joins("left outer join votes on votes.research_topic_id = research_topics.id and votes.deleted = 'f'").group("research_topics.id").order("vote_count asc") }
  scope :most_discussed, lambda { current.select("research_topics.*, count(posts.id) as post_count").joins(topic: :posts).group("research_topics.id").order("post_count desc") }
  scope :newest, lambda { current.order("research_topics.created_at desc") }

  # Class methods
  def self.popular(vote_threshold = nil)
    query = current.select("research_topics.*, (sum(votes.rating)::float/count(votes.rating)::float) as endorsement").joins(:votes).group("research_topics.id").order("endorsement desc")
    query = query.having("count(votes.rating) > ?", vote_threshold) if vote_threshold.present?
    query
  end

  def self.highlighted(user)
    # Similar to least voted, but making sure that user has not voted already
    approved
      .select("research_topics.*, count(votes.id) as vote_count")
      .joins("left outer join votes on votes.research_topic_id = research_topics.id and votes.deleted = 'f'")
      .group("research_topics.id").having("sum(case when votes.user_id = ? then 1 else 0 end) = 0", user.id)
      .order("vote_count asc")
      .first
  end

  # Getters
  def status
    topic.status if topic.present?
  end

  def text
    topic.name if topic.present?
  end

  def description
    topic.posts.first.description if topic.present? and !topic.posts.empty?
  end

  # Voting
  def endorsement
    Vote.current.select("sum(rating)::float/count(rating)::float as endorsement").group("research_topic_id").where(research_topic_id: self[:id]).map(&:endorsement).first
  end

  def endorse(user)
    votes.create(user_id: user.id, rating: 1)
  end


  def oppose(user)
    votes.create(user_id: user.id, rating: 0)
  end





  private

  def create_associated_topic

    self.create_topic(forum_id: Forum.find_by_slug(ENV["research_topic_forum_slug"]).id, name: @text,  description: @description, user_id: user.id)


    #topic.create( description: self.description, user_id: self.user_id )
    #self.get_or_create_subscription( self.user )
  end

end
