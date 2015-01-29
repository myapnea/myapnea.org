require 'test_helper.rb'

class VotesControllerTest < ActionController::TestCase

  setup do
    @regular_user = users(:user_1)
  end

  test "should vote for survey question as regular user" do
    login(users(:social))

    old_rating = questions(:q1).rating

    assert_equal old_rating, Vote.where(question_id: questions(:q1).id).count

    assert_difference "Vote.count" do
      xhr :post, :vote, vote: {question_id: questions(:q1).id, rating: '1'}, format: 'json'
    end

    assert_not_nil assigns(:vote)

    assert_equal questions(:q1).rating, old_rating + 1

  end

  test "should vote for research topic as regular user" do
    login(@regular_user)

    assert_difference "ResearchTopic.find_by_id(#{research_topics(:rt2).id}).rating" do
      assert_difference "Vote.count" do
        xhr :post, :vote, vote: { research_topic_id: research_topics(:rt2).id, rating: '1' }, format: 'js'
      end
    end

    assert_not_nil assigns(:research_topic)
    assert_not_nil assigns(:vote)

    assert_template 'vote'
    assert_response :success

  end

  test "should remove vote for research topic as regular user" do
    login(@regular_user)

    assert_difference "ResearchTopic.find_by_id(#{research_topics(:rt3).id}).rating", -1 do
      assert_difference "research_topics(:rt3).rating", -1 do
        xhr :post, :vote, vote: { research_topic_id: research_topics(:rt3).id, rating: '0' }, format: 'js'
      end
    end

    assert_not_nil assigns(:research_topic)
    assert_not_nil assigns(:vote)

    assert_template 'vote'
    assert_response :success
  end

end
