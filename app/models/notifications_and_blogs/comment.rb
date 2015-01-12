class Comment < ActiveRecord::Base
  include Deletable

  belongs_to :notification, counter_cache: true, touch: true
  has_many :votes
  belongs_to :research_topic, counter_cache: true, touch: true
end
