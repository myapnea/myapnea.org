require 'test_helper.rb'

class SurveysControllerTest < ActionController::TestCase
  test "User needs to be logged in to see surveys" do
    get :index

    assert_response 302
  end

  ## Assigned Surveys
  test "User can view an assigned survey" do
    login(users(:has_launched_survey))

    get :show, slug: answer_sessions(:launched).survey

    assert_response :success
  end

  test "User can answer question on an assigned survey" do
    login(users(:has_incomplete_survey))

    refute answer_sessions(:incomplete).completed?

    xhr :post, :process_answer, { 'question_id' => [questions(:checkbox1).id.to_s], 'answer_session_id' => answer_sessions(:incomplete).id.to_s,  questions(:checkbox1).id.to_s => { answer_templates(:race_list).id.to_s => [answer_options(:wookie).id.to_s, answer_options(:other_race).id.to_s], answer_templates(:specified_race).id.to_s => "Polish"}}, format: 'json'
    created_answer = assigns(:answer_session).last_answer

    assert created_answer.persisted?

    assert_equal answer_options(:wookie).id, created_answer.answer_values.first.answer_option_id
    assert_equal 3, created_answer.answer_values.count
    assert_equal "Wookie", created_answer.answer_values.first.answer_option.text
    assert_equal "Some other race", created_answer.answer_values.second.answer_option.text
    assert_equal "Polish", created_answer.answer_values.last.text_value

    assert assigns(:answer_session).completed?, "#{assigns(:answer_session).answers.complete.count} #{assigns(:answer_session).survey.questions.count} #{assigns(:answer_session).answers.to_a}"

    assert_response :success
  end

  test "User can view survey report for completed survey" do
    login(users(:has_completed_survey))

    assert answer_sessions(:complete).completed?

    get :show_report, slug: answer_sessions(:complete).survey

    assert_response :success
  end



  ## Unassigned Surveys

  test "User cannot view an unassigned survey" do
    login(users(:social))

    get :show, slug: surveys(:new)

    assert_redirected_to surveys_path
  end

  ## Incomplete Survey

  test "User cannot view survey report for assigned but unstarted survey" do
    login(users(:has_launched_survey))

    get :show_report, slug: answer_sessions(:launched).survey

    assert_redirected_to surveys_path



  end

  test "User cannot view survey report for incomplete survey" do
    login(users(:has_incomplete_survey))

    get :show_report, slug: answer_sessions(:incomplete).survey

    assert_redirected_to surveys_path
  end


  ## Complete Surveys
  test "should get completed survey for user" do
    login(users(:has_completed_survey))

    assert answer_sessions(:complete).completed?

    get :show, slug: surveys(:new)

    assert_not_nil assigns(:survey)

    assert_response :success

  end

  ## Index
  test "User can see index of surveys" do
    login(users(:has_launched_survey))

    get :index
    assert_equal 1, assigns(:surveys).length
    assert_equal users(:has_launched_survey).assigned_surveys, assigns(:surveys)

    assert_response :success
  end

  ## Survey Submition
  test "User can submit survey, locking all completed answers" do
    login(users(:has_completed_survey))
    assert answer_sessions(:complete).completed?

    xhr :post, :submit, answer_session_id: answer_sessions(:complete).id, format: 'json'

    answer_sessions(:complete).answers.each do |answer|
      assert answer.locked?
      old_val = answer.value
      answer.value = nil
      assert old_val, answer.value
    end
  end
end
