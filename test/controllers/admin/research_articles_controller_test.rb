require 'test_helper'

class Admin::ResearchArticlesControllerTest < ActionController::TestCase
  setup do
    @admin = users(:owner)
    @admin_research_article = admin_research_articles(:one)
  end

  test 'should get photo for logged out user' do
    get :photo, id: @admin_research_article
    assert_response :success
  end

  test "should get index" do
    login(@admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_research_articles)
  end

  test "should get new" do
    login(@admin)
    get :new
    assert_response :success
  end

  test "should create admin_research_article" do
    login(@admin)
    assert_difference('Admin::ResearchArticle.count') do
      post :create, admin_research_article: { author: 'New author', content: 'This is a new article', credentials: 'Professor', description: 'New article', references: 'Some research article', slug: 'new-research-article', title: '7 ways to improve your sleep' }
    end

    assert_redirected_to admin_research_article_path(assigns(:admin_research_article))
  end

  test "should show admin_research_article" do
    login(@admin)
    get :show, id: @admin_research_article
    assert_response :success
  end

  test "should get edit" do
    login(@admin)
    get :edit, id: @admin_research_article
    assert_response :success
  end

  test "should update admin_research_article" do
    login(@admin)
    patch :update, id: @admin_research_article, admin_research_article: { author: 'Different author' }
    assert_redirected_to admin_research_article_path(assigns(:admin_research_article))
  end

  test "should destroy admin_research_article" do
    login(@admin)
    assert_difference('Admin::ResearchArticle.current.count', -1) do
      delete :destroy, id: @admin_research_article
    end

    assert_redirected_to admin_research_articles_path
  end
end
