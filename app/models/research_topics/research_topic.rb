# Research topic belongs to forum topic

class ResearchTopic < ActiveRecord::Base
  # Concerns
  include Deletable
  include Authority::Abilities

  # Accessors
  attr_writer :description, :text

  # Associations
  belongs_to :user
  belongs_to :topic #, -> { includes :posts }
  has_many :votes

  # Constants
  PROGRESS = [:proposed, :accepted, :ongoing_research, :complete]

  # Callbacks
  after_create :create_associated_topic

  # Named Scopes
  scope :approved, lambda { joins(:topic).where(topics: {status: 'approved'})}
  scope :pending_review, lambda { joins(:topic).where(topics: {status: 'pending_review'})}

  # scope :viewable_by_user, lambda { |arg| where('topics.status = ? or topics.user_id = ?', 'approved', arg) }
  # scope :pending_review, -> { where('topics.status = ? or topics.id IN (select posts.topic_id from posts where posts.deleted = ? and posts.status = ?)', 'pending_review', false, 'pending_review') }

  #scope :accepted, -> { where(state: 'accepted') }
  #scope :viewable_by, lambda { |user_id| where("state = ? or user_id = ?", "accepted", user_id)}



  # Getters
  def status
    topic.status
  end

  def text
    topic.name
  end

  def description
    topic.posts.first.description
  end

  # Voting
  def endorsement
    Vote.select("sum(rating)::float/count(rating)::float as endorsement").group("research_topic_id").where(research_topic_id: self[:id]).map(&:endorsement).first.round(4)
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
