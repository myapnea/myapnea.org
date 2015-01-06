require "test_helper"

class ForumTest < ActiveSupport::TestCase

  def forum
    @forum ||= users(:owner).forums.new(name: 'NewName', slug: 'new-slug')
  end

  def test_valid
    assert forum.valid?
  end

end
