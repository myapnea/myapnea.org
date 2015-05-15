class Post < ActiveRecord::Base

  STATUS = [['Approved', 'approved'], ['Pending Review', 'pending_review'], ['Marked as Spam', 'spam'], ['Hidden', 'hidden']]

  # Concerns
  include Deletable

  # Callbacks
  after_save :touch_topic

  # Named Scopes
  scope :with_unlocked_topic, -> { where("posts.topic_id in (select topics.id from topics where topics.locked = ?)", false).references(:topics) }
  ## Temporary exclusion of ResearchTopic forum:
  #scope :visible_for_user, lambda { |arg| joins(topic: :forum).where("forums.slug != ? and posts.status = ? or posts.user_id = ?", ENV["research_topic_forum_slug"], 'approved', arg) }
  scope :visible_for_user, lambda { |arg| joins(topic: :forum).where("posts.status = ? or posts.user_id = ?", 'approved', arg) }
  scope :not_research, -> { where('posts.topic_id NOT IN (select research_topics.topic_id from research_topics where research_topics.topic_id IS NOT NULL)')}

  # Model Validation
  validates_presence_of :description, :user_id, :topic_id

  # Model Relationships
  belongs_to :user
  belongs_to :topic
  belongs_to :last_moderated_by, class_name: 'User'

  # Post Methods

  def forum
    self.topic.forum
  end

  def editable_by?(current_user)
    # not self.topic.locked? and not self.user.banned? and (self.user == current_user.has_role? :moderator)
    not self.topic.locked? and (self.user == current_user or current_user.has_role? :moderator)
  end

  def deletable_by?(current_user)
    self.user == current_user or current_user.has_role? :moderator
  end

  def number
    self.topic.posts.order(:id).pluck(:id).index(self.id) + 1 rescue 0
  end

  def page
    ((self.number - 1) / Topic::POSTS_PER_PAGE) + 1
  end

  def anchor
    "c#{self.number}"
  end

  def pending_review?
    self.status == 'pending_review'
  end

  def spam?
    self.status == 'spam'
  end

  def hidden?
    self.status == 'hidden'
  end

  def approved?
    self.status == 'approved'
  end

  # Reply Emails sends emails if the following conditions are met:
  # 1) The topic subscriber has email notifications enabled
  # AND
  # 2) The topic subscriber is not the post creator
  def send_reply_emails!
    unless Rails.env.test? or Rails.env.development?
      pid = Process.fork
      if pid.nil? then
        # In child
        self.topic.subscribers.where.not(id: self.user_id).each do |u|
          UserMailer.post_replied(self, u).deliver_later if Rails.env.production?
        end
        Kernel.exit!
      else
        # In parent
        Process.detach(pid)
      end
    end
  end

  private

  def touch_topic
    self.topic.set_last_post_at!
  end

  # def email_mentioned_users
  #   users = User.current.where(email_me_when_mentioned: true).reject{|u| u.username.blank?}.uniq.sort
  #   users.each do |user|
  #     UserMailer.mentioned_in_comment(self, user).deliver_later if Rails.env.production? and self.description.match(/@#{user.username}\b/i)
  #   end
  # end

end
