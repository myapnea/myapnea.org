# frozen_string_literal: true

require 'test_helper'

# Tests to assure that community members can create and view forum topics.
class ChaptersControllerTest < ActionController::TestCase
  setup do
    @chapter = chapters(:one)
    login(users(:user_1))
  end

  def chapter_params
    {
      title: 'Topic Title',
      slug: 'topic-title',
      description: 'This is the my new forum topic.',
      pinned: '1'
    }
  end

  test 'should get index' do
    get :index
    assert_response :success
    assert_not_nil assigns(:chapters)
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should create chapter' do
    assert_difference('Chapter.count') do
      post :create, chapter: chapter_params
    end
    assert_not_nil assigns(:chapter)
    assert_equal 'Topic Title', assigns(:chapter).title
    assert_equal 'This is the my new forum topic.', assigns(:chapter).replies.first.description
    assert_equal users(:user_1), assigns(:chapter).user
    assert_redirected_to assigns(:chapter)
  end

  test 'should not create chapter with blank title' do
    assert_difference('Chapter.count', 0) do
      post :create, chapter: chapter_params.merge(title: '')
    end
    assert_template 'new'
    assert_response :success
  end

  test 'should show chapter' do
    get :show, id: @chapter
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @chapter
    assert_response :success
  end

  test 'should update chapter' do
    patch :update, id: @chapter, chapter: chapter_params
    assert_redirected_to assigns(:chapter)
  end

  test 'should not update chapter with blank title' do
    patch :update, id: @chapter, chapter: chapter_params.merge(title: '')
    assert_template 'edit'
    assert_response :success
  end

  test 'should destroy chapter' do
    assert_difference('Chapter.current.count', -1) do
      delete :destroy, id: @chapter
    end
    assert_redirected_to chapters_path
  end
end
