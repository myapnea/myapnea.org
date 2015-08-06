# Research topic belongs to forum topic

class ResearchTopic < ActiveRecord::Base
  # Concerns
  include Deletable

  # Accessors
  attr_writer :description, :text

  # Associations
  belongs_to :user
  belongs_to :topic
  has_many :votes, -> { where(deleted: false) }

  # Constants
  PROGRESS = [:proposed, :accepted, :ongoing_research, :complete]
  TYPE = [:user_submitted, :seeded]
  INTRO_LENGTH = ENV["research_topic_experience_threshold"].to_i
  RESEARCH_TOPIC_DATA_LOCATION = ['lib', 'data', 'research_topics']

  # Validations

  #validate :description_and_text_are_present, on: :create
  validates_presence_of :user_id, :description, :text

  # def description_and_text_are_present
  #   errors.add(:description, "needs to be provided.") if @description.blank?
  #   errors.add(:text, "needs to be provided.") if @text.blank?
  # end

  # Callbacks
  after_create :create_associated_topic

  # Named Scopes
  scope :approved, lambda { current.joins(:topic).where(topics: {status: 'approved'})}
  scope :pending_review, lambda { current.joins(:topic).where(topics: {status: 'pending_review'})}
  scope :most_voted, lambda { current.select("research_topics.*, count(votes.id) as vote_count").joins("left outer join votes on votes.research_topic_id = research_topics.id and votes.deleted = 'f'").group(group_columns).order("vote_count desc") }
  scope :least_voted, lambda { current.select("research_topics.*, count(votes.id) as vote_count").joins("left outer join votes on votes.research_topic_id = research_topics.id and votes.deleted = 'f'").group(group_columns).order("vote_count asc") }
  scope :most_discussed, lambda { current.select("research_topics.*, count(posts.id) as post_count").joins(topic: :posts).group(group_columns).order("post_count desc") }
  scope :newest, lambda { current.order("research_topics.created_at desc") }

  # Class methods
  def self.find_by_slug(slug)
    topic = Topic.find_by_slug(slug)

    topic.research_topic if topic.present?
  end

  def self.popular(vote_threshold = nil)
    query = current.select("research_topics.*, (sum(votes.rating)::float/count(votes.rating)::float) as endorsement").joins(:votes).group(group_columns).order("endorsement desc")
    query = query.having("count(votes.rating) > ?", vote_threshold) if vote_threshold.present?
    query
  end

  def self.highlighted(user)
    # Similar to least voted, but making sure that user has not voted already
    approved
      .select("research_topics.*, count(votes.id) as vote_count")
      .joins("left outer join votes on votes.research_topic_id = research_topics.id and votes.deleted = 'f'")
      .group(group_columns).having("sum(case when votes.user_id = ? then 1 else 0 end) = 0", user.id)
      .order("vote_count asc")
  end

  def self.seeded(user)
    where("research_topics.category = ?", "seeded").highlighted(user)
  end

  def self.load_seeds
    loaded_successfully = []
    loaded_with_problems = []
    msgs = []

    data_file = YAML.load_file(Rails.root.join(*(RESEARCH_TOPIC_DATA_LOCATION + ["original_seeding.yml"])))

    data_file['research_topics'].each do |research_topic_attributes|
      user = User.find_by_email(research_topic_attributes.delete("user_email"))

      if user.present?
        loaded_successfully << research_topic_attributes
      else
        loaded_with_problems << research_topic_attributes
        user = User.first
        msgs << "User #{research_topic_attributes["user_email"]} not found for research topic #{research_topic_attributes["text"]}\nAssigning #{user.email} as a fallback."
      end

      rt = create({category: 'seeded', progress: 'proposed', user_id: user.id}.merge(research_topic_attributes))
      rt.topic.update(status: 'approved')
      rt.topic.posts.first.update(status: 'approved') if rt.topic.posts.first.present?
    end

    {successful: loaded_successfully, with_problems: loaded_with_problems, messages: msgs }
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


  # Voting
  def endorsement
    Vote.current.select("sum(rating)::float/count(rating)::float as endorsement").group("research_topic_id").where(research_topic_id: self[:id]).map(&:endorsement).first
  end

  def endorse_by(user, comment = nil)
    cast_vote(user, 1, comment)

  end

  def oppose_by(user, comment = nil)
    cast_vote(user, 0, comment)
  end

  def voted_by_user?(user = nil)
    if user == nil
      return false
    else
      return self.votes.current.where(user_id: user.id).present?
    end
  end


  # Categories

  def seeded?
    category == "seeded"
  end


  private

  def cast_vote(user, rating, comment)
    if user.cast_vote_for?(self)
      votes.find_by_user_id(user.id).update(rating: rating)
    else
      votes.create(user_id: user.id, rating: rating)
    end

    if comment.present?
      topic.posts.create(description: comment, user_id: user.id)
    end
  end

  def self.group_columns
    column_names.map{|cn| "research_topics.#{cn}"}.join(", ")
  end

  def create_associated_topic
    self.create_topic(forum_id: Forum.for_research_topics.id, name: @text,  description: @description, user_id: user.id)
  end

end
