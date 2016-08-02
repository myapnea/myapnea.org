# frozen_string_literal: true

# Research topic belongs to forum topic

class ResearchTopic < ApplicationRecord
  # Concerns
  include Deletable

  # Accessors
  attr_writer :description, :text

  # Associations
  belongs_to :user
  belongs_to :topic

  # Constants
  PROGRESS = [:proposed, :accepted, :ongoing_research, :complete]
  TYPE = [:user_submitted, :seeded]
  INTRO_LENGTH = 0 # ENV['research_topic_experience_threshold'].to_i

  # Validations
  validates :user_id, :description, :text, presence: true

  # Scopes
  scope :approved, lambda { current.joins(:topic).where(topics: {status: 'approved'})}
  scope :pending_review, lambda { current.joins(:topic).where(topics: {status: 'pending_review'})}
  scope :most_discussed, lambda { current.select("research_topics.*, count(posts.id) as post_count").joins(topic: :posts).group(group_columns).order("post_count desc") }
  scope :newest, lambda { current.order("research_topics.created_at desc") }
  scope :article_eligible, -> { current.where(progress: [:accepted, :ongoing_research, :complete]) }

  # Class methods
  def self.find_by_slug(slug)
    topic = Topic.find_by_slug(slug)
    topic.research_topic if topic.present?
  end

  def self.popular(vote_threshold = nil)
    current
  end

  def self.highlighted(user)
    approved
  end

  def self.seeded(user)
    where("research_topics.category = ?", "seeded").highlighted(user)
  end

  # Getters
  def status
    topic.status if topic.present?
  end

  def text
    topic.present? ? topic.name : @text
  end

  def description
    if topic.present? and !topic.posts.empty?
      topic.posts.first.description
    else
      @description
    end
  end

  def slug
    topic.slug if topic.present?
  end

  def to_param
    slug
  end

  # Categories

  def seeded?
    category == "seeded"
  end

  def create_associated_topic!
    create_topic(forum_id: Forum.for_research_topics.id, name: @text, description: @description, user_id: user.id)
  end

  private

  def self.group_columns
    column_names.map{|cn| "research_topics.#{cn}"}.join(", ")
  end
end
