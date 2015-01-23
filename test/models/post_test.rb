require "test_helper"

class PostTest < ActiveSupport::TestCase

  def post
    @post ||= users(:user_1).posts.where(topic_id: topics(:one).id).new(description: "Post on Topic One")
  end

  def test_valid
    assert post.valid?
  end

end
