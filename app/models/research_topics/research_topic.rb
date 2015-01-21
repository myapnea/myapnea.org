class ResearchTopic < ActiveRecord::Base
  include Votable, Deletable

  has_many :votes

  include Authority::Abilities

  belongs_to :user

  STATES = [:under_review, :proposed, :accepted, :rejected, :complete, :hidden]

  scope :accepted, -> { where(state: 'accepted') }
  scope :viewable_by, lambda { |user_id| where("state = ? or user_id = ?", "accepted", user_id)}

  def self.popular(user_id = nil)

    current.viewable_by(user_id).includes(:votes).sort do |rt1, rt2|
      sort_topics(rt1, rt2)
    end
  end

  def self.voted_by(user)
    current.accepted.joins(:votes).where(votes: {user_id: user.id, rating: 1} ).sort do |rt1, rt2|
      sort_topics(rt1, rt2)
    end
  end

  def self.created_by(user)
    current.where(user_id: user.id)
  end

  def self.newest(user_id = nil)
    current.viewable_by(user_id).order("created_at DESC")
  end

  def voted_on_percentage
    ( self.votes.where(rating: 1).count * 100) / ( Vote.total_number_voters.nonzero? || 1 )
  end

  def received_vote_from?(user)
    self.votes.where(user_id: user.id, rating: 1).present? ? true : false
  end

  def accepted?
    state == 'accepted'
  end

  def proposed_by
    User.where(id: self.user_id).first
  end

  private

  def self.sort_topics(rt1, rt2)
    comp = rt2.rating <=> rt1.rating
    comp.zero? ? (rt1.created_at <=> rt2.created_at) : comp
  end

end
