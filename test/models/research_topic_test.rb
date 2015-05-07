require "test_helper"

class ResearchTopicTest < ActiveSupport::TestCase
  test "Research topic creation" do
    u = users(:user_1)
    text = "Does sleep apnea cause obesity, or is it the other way around?"
    desc = "This question has been on my mind for quite a long time, and I'm sure others have wondered about it as well."


    assert_difference [ 'Topic.pending_review.count', 'ResearchTopic.pending_review.count' ], 1 do
      rt = ResearchTopic.create(user_id: u.id, text: t, description: d)
    end

    assert rt.topic
    t = rt.topic

    assert_equal u, t.user
    assert_equal u, rt.user

    assert_equal text, t.title
    assert_equal text, rt.text

    assert_equal desc, t.description
    assert_equal desc, rt.description
  end

end
