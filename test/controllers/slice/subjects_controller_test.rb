require "test_helper"

class Slice::SubjectsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @subject = subjects(:one)
    @regular = users(:valid)
  end

  def subject_params
    {
      project_id: projects(:two).id
    }
  end

  test "should get index" do
    login(@regular)
    get slice_subjects_url
    assert_response :success
  end

  test "should get new" do
    login(@regular)
    get new_slice_subject_url
    assert_response :success
  end

  test "should create subject" do
    login(@regular)
    assert_difference("Subject.count") do
      post slice_subjects_url, params: { subject: subject_params }
    end
    assert_redirected_to slice_surveys_url
  end

  test "should show subject" do
    login(@regular)
    get slice_subject_url(@subject)
    assert_response :success
  end

  test "should get edit" do
    login(@regular)
    get edit_slice_subject_url(@subject)
    assert_response :success
  end

  test "should update subject" do
    login(@regular)
    patch slice_subject_url(@subject), params: { subject: subject_params }
    assert_redirected_to slice_surveys_url
  end

  test "should destroy subject" do
    login(@regular)
    assert_difference("Subject.count", -1) do
      delete slice_subject_url(@subject)
    end
    assert_redirected_to slice_surveys_url
  end
end
