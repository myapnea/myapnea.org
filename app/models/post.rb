class Post < ActiveRecord::Base

  STATUS = [['Approved', 'approved'], ['Pending Review', 'pending_review'], ['Marked as Spam', 'spam']]

  # Concerns
  include Deletable

  # Callbacks

  # Named Scopes
  scope :with_unlocked_topic, -> { where("posts.topic_id in (select topics.id from topics where topics.locked = ?)", false).references(:topics) }

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

  def pending_review?
    self.status == 'pending_review'
  end

  def spam?
    self.status == 'spam'
  end

  private

  def touch_topic
    self.topic.update last_post_at: Time.now
  end

  # def email_mentioned_users
  #   users = User.current.where(email_me_when_mentioned: true).reject{|u| u.username.blank?}.uniq.sort
  #   users.each do |user|
  #     UserMailer.mentioned_in_comment(self, user).deliver_later if Rails.env.production? and self.description.match(/@#{user.username}\b/i)
  #   end
  # end

end
