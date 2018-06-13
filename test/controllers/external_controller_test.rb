# frozen_string_literal: true

require "test_helper"

# Test for publicly available pages.
class ExternalControllerTest < ActionDispatch::IntegrationTest
  setup do
    @regular = users(:regular)
  end

  test "should get about" do
    get about_url
    assert_response :success
  end

  test "should get article" do
    get article_url(broadcasts(:published).slug)
    assert_response :success
  end

  test "should up vote article" do
    login(@regular)
    assert_difference("ArticleVote.where(rating: 1).count") do
      post article_vote_url(broadcasts(:published).slug, vote: "up", format: "js")
    end
    assert_template "article_vote"
    assert_response :success
  end

  test "should down vote article" do
    login(@regular)
    assert_difference("ArticleVote.where(rating: -1).count") do
      post article_vote_url(broadcasts(:published).slug, vote: "down", format: "js")
    end
    assert_template "article_vote"
    assert_response :success
  end

  test "should not vote on article as public user" do
    assert_difference("ArticleVote.where(rating: 1).count", 0) do
      post article_vote_url(broadcasts(:published).slug, vote: "up", format: "js")
    end
    assert_template "article_vote"
    assert_response :success
  end

  test "should get contact" do
    get contact_url
    assert_response :success
  end

  test "should get landing" do
    get landing_url
    assert_response :success
  end

  test "should get landing for regular user" do
    login(@regular)
    get landing_url
    assert_response :success
  end

  test "should get partners" do
    get partners_url
    assert_response :success
  end

  test "should get partner photo as public user" do
    get partner_photo_url(admin_partners(:two))
    assert_equal File.binread(admin_partners(:two).photo.path), response.body
    assert_response :success
  end

  test "should get privacy policy" do
    get privacy_policy_url
    assert_response :success
  end

  test "should get sitemap xml file" do
    get sitemap_xml_url
    assert_response :success
  end

  test "should get team" do
    get team_url
    assert_response :success
  end

  test "should get team member photo as public user" do
    get team_member_photo_url(admin_team_members(:two))
    assert_equal File.binread(admin_team_members(:two).photo.path), response.body
    assert_response :success
  end

  test "should get terms of access" do
    get terms_of_access_url
    assert_response :success
  end

  test "should get terms and conditions" do
    get terms_and_conditions_url
    assert_response :success
  end

  test "should get voting" do
    get voting_url
    assert_response :success
  end

  test "should get version" do
    get version_url
    assert_response :success
  end

  test "should get version as json" do
    get version_url(format: "json")
    version = JSON.parse(response.body)
    assert_equal Myapnea::VERSION::STRING, version["version"]["string"]
    assert_equal Myapnea::VERSION::MAJOR, version["version"]["major"]
    assert_equal Myapnea::VERSION::MINOR, version["version"]["minor"]
    assert_equal Myapnea::VERSION::TINY, version["version"]["tiny"]
    if Myapnea::VERSION::BUILD.nil?
      assert_nil version["version"]["build"]
    else
      assert_equal Myapnea::VERSION::BUILD, version["version"]["build"]
    end
    assert_response :success
  end
end
