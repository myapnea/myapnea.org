require "test_helper"

class ResearchTopicTest < ActiveSupport::TestCase
  test "self.highlighted" do
    # User 10 has voted for neither research topic (rt1 or rt3)
    assert_not_nil ResearchTopic.highlighted(users(:user_10)).first
    # User 7 already voted for lowest voted research topic (rt3), so he should see rt1
    assert_not_nil ResearchTopic.highlighted(users(:user_7)).first
    # User 1 has voted for all approved research topics and should not see any
    assert_nil ResearchTopic.highlighted(users(:user_1)).first
  end

  test "self.seeded" do
    assert_difference("ResearchTopic.seeded(users(:user_2)).length", -1) do
      ResearchTopic.where(category: "seeded").first.endorse_by(users(:user_2))
    end
  end

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

    assert_not_nil rt.topic.posts.first

    assert_equal u, t.user
    assert_equal u, rt.user

    assert_equal text, t.name
    assert_equal text, rt.text

    assert_equal desc, t.description
    assert_equal desc, rt.description
  end

  test "Research topic cannot be created without description" do
    u = users(:user_1)
    text = "Does sleep apnea cause obesity, or is it the other way around?"
    desc = nil

    rt = nil

    assert_no_difference [ 'Topic.pending_review.count', 'ResearchTopic.pending_review.count' ] do
      rt = ResearchTopic.create(user_id: u.id, text: text, description: desc)
    end

    refute rt.valid?
  end

  test "Research topic endorsement" do
    u = users(:user_10)
    rt = research_topics(:rt1)

    assert_equal 0.6, rt.endorsement

    rt.endorse_by(u)

    assert_in_epsilon (4.0/6.0), rt.endorsement
  end

  test "Research topic opposition" do
    u = users(:user_10)
    rt = research_topics(:rt3)

    assert_equal 0.75, rt.endorsement

    rt.oppose_by(u)

    assert_equal 0.6, rt.endorsement
  end

  test "Research topic commenting when voting" do
    u = users(:user_10)
    rt = research_topics(:rt1)
    comment = "some comment for this topic"

    rt.endorse_by(u, comment)

    assert_equal comment, rt.topic.posts.last.description
  end

  test "Research topic voting should not allow double-voting" do
    u = users(:user_1)
    rt = research_topics(:rt1)


    assert_no_difference "Vote.count" do
      rt.endorse_by(u)
    end

    assert_no_difference "Vote.count" do
      rt.oppose_by(u)
    end


  end

  test "Vote can be switched from endorsement to opposition and vice-versa" do

    u = users(:user_10)
    rt = research_topics(:rt3)

    assert_in_epsilon 0.75, rt.endorsement

    rt.endorse_by(u)

    assert_in_epsilon (4.0/5.0), rt.endorsement

    rt.oppose_by(u)

    assert_in_epsilon (3.0/5.0), rt.endorsement

    rt.endorse_by(users(:user_1))

    assert_equal (4.0/5.0), rt.endorsement
  end
end
