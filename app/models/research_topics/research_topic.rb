# Research topic belongs to forum topic

class ResearchTopic < ActiveRecord::Base
  include Deletable

  include Authority::Abilities

  belongs_to :user
  belongs_to :topic, -> { includes :posts }

  PROGRESS = [:proposed, :accepted, :ongoing_research, :complete]

  #scope :accepted, -> { where(state: 'accepted') }
  #scope :viewable_by, lambda { |user_id| where("state = ? or user_id = ?", "accepted", user_id)}

  def status
    topic.status
  end

  private

end
