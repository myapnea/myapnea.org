class Vote < ActiveRecord::Base

  include Deletable

  # Always needs to belong to user
  belongs_to :user

  # Can only belong to ONE of the following
  belongs_to :research_topic


  def create_post(comment)
    self.research_topic.topic.posts.create( description: comment, user_id: self.user_id )
    self.research_topic.topic.get_or_create_subscription( self.user )
  end

  private

end
