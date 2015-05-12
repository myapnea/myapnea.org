require "test_helper"

class ResearchTopicTest < ActiveSupport::TestCase
  test "self.highlighted" do
    # User 10 has voted for neither research topic (rt1 or rt3)
    assert_equal research_topics(:rt3), ResearchTopic.highlighted(users(:user_10)).first

    # User 7 already voted for lowest voted research topic (rt3), so he should see rt1
    assert_equal research_topics(:rt1), ResearchTopic.highlighted(users(:user_7)).first

    # User 1 has voted for all approved research topics and should not see any
    assert_nil ResearchTopic.highlighted(users(:user_1)).first
  end

  test "self.approved" do
    assert_equal 2, ResearchTopic.approved.length
  end

  test "self.popular" do
    assert_equal 2, ResearchTopic.popular.length
    assert_equal 1, ResearchTopic.popular(4).length
    assert_equal 0, ResearchTopic.popular(10).length

    assert_equal [0.75, 0.6], ResearchTopic.popular.map(&:endorsement)
    assert_equal [0.6], ResearchTopic.popular(4).map(&:endorsement)
  end

  test "self.most_discussed" do
    assert_equal 3, ResearchTopic.most_discussed.length
    assert_equal [2,1,1], ResearchTopic.most_discussed.map(&:post_count)

  end

  test "self.most_voted" do
    assert_equal 3, ResearchTopic.most_voted.length
    assert_equal [5,4,0], ResearchTopic.most_voted.map(&:vote_count)
  end

  test "self.newest" do
    assert_equal 3, ResearchTopic.newest.length
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

    assert_in_epsilon (4.0/6.0), rt.endorsement
  end

  test "Research topic opposition" do
    u = users(:user_10)
    rt = research_topics(:rt3)

    assert_equal 0.75, rt.endorsement

    rt.oppose(u)

    assert_equal 0.6, rt.endorsement
  end
end
