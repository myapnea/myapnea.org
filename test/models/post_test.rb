require "test_helper"

class PostTest < ActiveSupport::TestCase

  def post
    @post ||= Post.new
  end

  def test_valid
    skip
    assert post.valid?
  end

end
