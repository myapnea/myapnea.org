require 'test_helper'

class HighlightsControllerTest < ActionController::TestCase
  setup do
    @highlight = highlights(:one)
    @owner = users(:owner)
    @regular_user = users(:user_1)
  end

  test 'should get photo for logged out user' do
    get :photo, id: @highlight
    assert_response :success
  end

  test "should get index for owner" do
    login(@owner)
    get :index
    assert_response :success
    assert_not_nil assigns(:highlights)
  end

  test "should not get index for regular user" do
    login(@regular_user)
    get :index
    assert_redirected_to root_path
  end

  test "should get new" do
    login(@owner)
    get :new
    assert_response :success
  end

  test "should not get new for regular user" do
    login(@regular_user)
    get :new
    assert_redirected_to root_path
  end

  test "should create highlight" do
    login(@owner)
    assert_difference('Highlight.count') do
      post :create, highlight: { title: @highlight.title, description: @highlight.description, display_date: @highlight.display_date, photo: @highlight.photo }
    end

    assert_redirected_to highlight_path(assigns(:highlight))
  end

  test "should not create highlight with blank title" do
    login(@owner)
    assert_difference('Highlight.count', 0) do
      post :create, highlight: { title: '', description: @highlight.description, display_date: @highlight.display_date, photo: @highlight.photo }
    end
    assert_not_nil assigns(:highlight)
    assert assigns(:highlight).errors.size > 0
    assert_equal ["can't be blank"], assigns(:highlight).errors[:title]
    assert_template 'new'
    assert_response :success
  end

  test "should not create highlight for regular user" do
    login(@regular_user)
    assert_difference('Highlight.count', 0) do
      post :create, highlight: { title: @highlight.title, description: @highlight.description, display_date: @highlight.display_date, photo: @highlight.photo }
    end

    assert_redirected_to root_path
  end

  test "should show highlight" do
    login(@owner)
    get :show, id: @highlight
    assert_response :success
  end

  test "should not get show for regular user" do
    login(@regular_user)
    get :show, id: @highlight
    assert_redirected_to root_path
  end

  test "should get edit" do
    login(@owner)
    get :edit, id: @highlight
    assert_response :success
  end

  test "should not get edit for regular user" do
    login(@regular_user)
    get :edit, id: @highlight
    assert_redirected_to root_path
  end

  test "should update highlight" do
    login(@owner)
    patch :update, id: @highlight, highlight: { title: @highlight.title, description: @highlight.description, display_date: @highlight.display_date, photo: @highlight.photo }
    assert_redirected_to highlights_path
  end

  test "should not update highlight with blank title" do
    login(@owner)
    patch :update, id: @highlight, highlight: { title: '', description: @highlight.description, display_date: @highlight.display_date, photo: @highlight.photo }
    assert_not_nil assigns(:highlight)
    assert assigns(:highlight).errors.size > 0
    assert_equal ["can't be blank"], assigns(:highlight).errors[:title]
    assert_template 'edit'
    assert_response :success
  end


  test "should not update highlight for regular user" do
    login(@regular_user)
    get :update, id: @highlight
    assert_nil assigns(:highlight)
    assert_redirected_to root_path
  end

  test "should destroy highlight" do
    login(@owner)
    assert_difference('Highlight.current.count', -1) do
      delete :destroy, id: @highlight
    end

    assert_redirected_to highlights_path
  end

  test "should not destroy highlight for regular user" do
    login(@regular_user)
    assert_difference('Highlight.current.count', 0) do
      delete :destroy, id: @highlight
    end
    assert_redirected_to root_path
  end

end
