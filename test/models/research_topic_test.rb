require "test_helper"

class ResearchTopicTest < ActiveSupport::TestCase
  test "Research topic creation" do
    u = users(:user_1)
    text = "Does sleep apnea cause obesity, or is it the other way around?"
    desc = "This question has been on my mind for quite a long time, and I'm sure others have wondered about it as well."

    rt = nil

    assert_difference [ 'Topic.pending_review.count', 'ResearchTopic.pending_review.count' ], 1 do
      rt = ResearchTopic.create(user_id: u.id, text: text, description: desc)
    end

    assert rt.topic
    t = rt.topic

    assert_equal u, t.user
    assert_equal u, rt.user

    assert_equal text, t.name
    assert_equal text, rt.text

    assert_equal desc, t.description
    assert_equal desc, rt.description
  end

  test "Research topic endorsement" do
    u = users(:user_10)
    rt = research_topics(:rt1)

    assert_equal 0.6, rt.endorsement

    rt.endorse(u)

    assert_equal (4.0/6.0).round(4), rt.endorsement
  end

  test "Research topic opposition" do
    u = users(:user_10)
    rt = research_topics(:rt3)

    assert_equal 0.75, rt.endorsement

    rt.oppose(u)

    assert_equal 0.6, rt.endorsement
  end
end
