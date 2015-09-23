class Post < ActiveRecord::Base

  STATUS = [['Approved', 'approved'], ['Pending Review', 'pending_review'], ['Marked as Spam', 'spam'], ['Hidden', 'hidden']]

  # Concerns
  include Deletable

  # Callbacks
  after_save :touch_topic

  # Named Scopes
  scope :with_unlocked_topic, -> { where("posts.topic_id in (select topics.id from topics where topics.locked = ?)", false).references(:topics) }
  scope :visible_for_user, -> { where(status: ['approved', 'pending_review']).joins(:topic).where("topics.status IN (?) and topics.deleted = ?", ['approved', 'pending_review'], false) }
  scope :not_research, -> { where('posts.topic_id NOT IN (select research_topics.topic_id from research_topics where research_topics.topic_id IS NOT NULL)')}

  # Model Validation
  validates_presence_of :description, :user_id, :topic_id

  # Model Relationships
  belongs_to :user
  belongs_to :topic
  belongs_to :last_moderated_by, class_name: 'User'
  belongs_to :last_moderated_by, class_name: 'User'
  belongs_to :deleted_by, class_name: 'User'

  # Post Methods

  def forum
    self.topic.forum
  end

  def destroy_by_user(current_user)
    self.update(status: (self.status == 'pending_review' ? 'hidden' : self.status), deleted_by_id: current_user.id)
    self.destroy
  end

  def editable_by?(current_user)
    not self.topic.locked? and (self.user == current_user or current_user.moderator?)
  end

  def deletable_by?(current_user)
    self.user == current_user or current_user.owner?
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

  def is_first_post?
    self.topic.posts.first == self
  end

  # Reply Emails sends emails if the following conditions are met:
  # 1) The topic subscriber has email notifications enabled
  # AND
  # 2) The topic subscriber is not the post creator
  def send_reply_emails!
    return # Temporarily disable forum reply emails
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
