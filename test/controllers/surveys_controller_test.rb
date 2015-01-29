require 'test_helper.rb'

class SurveysControllerTest < ActionController::TestCase
  test "User can start a survey" do
    login(users(:social))

    get :start_survey, survey_id: surveys(:survey_1).id

    assert_redirected_to ask_question_path(question_id: surveys(:survey_1).first_question_id, answer_session_id: AnswerSession.most_recent(surveys(:survey_1).id, users(:social).id).id)
  end

  test "User can view survey intro" do
    login(users(:social))

    get :intro, survey_id: surveys(:survey_1).id

    assert_equal surveys(:survey_1), assigns(:survey)
    refute assigns(:answer_session)
    assert_nil AnswerSession.most_recent(assigns(:survey).id, users(:social).id)
    assert_template "surveys/intro"
  end

  test "User can view question on survey" do
    login(users(:has_unstarted_survey))

    get :ask_question, question_id: surveys(:survey_1).first_question.id, answer_session_id: answer_sessions(:unstarted)
    assert_response :success
    assert_not_nil assigns(:answer)

  end

  test "User can view grouped question on survey" do
    login(users(:has_incomplete_survey))

    get :ask_question, question_id: questions(:q3b).id, answer_session_id: answer_sessions(:incomplete).id

    assert_response :success
    assert_not_nil assigns(:group)
    assert_not_nil assigns(:questions)
  end

  test "User can answer question on survey" do
    login(users(:has_incomplete_survey))
    assert users(:has_incomplete_survey).ready_for_research?

    post :process_answer, { 'question_id' => questions(:q3c).id, 'answer_session_id' => answer_sessions(:incomplete).id,  questions(:q3c).id.to_s => 22, "direction" => "next"}

    assert_not_nil assigns(:answer_session)

    assert_redirected_to survey_report_path(assigns(:answer_session))
  end

  test "User can view survey report" do
    login(users(:has_completed_survey))

    get :show_report, answer_session_id: answer_sessions(:complete)

    assert_response :success
  end

  test "Survey report does not break when survey not started" do
    login(users(:has_unstarted_survey))


    get :show_report, answer_session_id: answer_sessions(:unstarted)

    assert_response :success
  end

  test "Surveys cannot be restarted once they are completed without explicit warning" do
    login(users(:has_completed_survey))

    get :start_survey, survey_id: surveys(:survey_1).id

    assert_redirected_to surveys_path

  end

  test "Surveys cannot be restarted even when verified by user" do
    login(users(:has_completed_survey))

    get :start_survey, survey_id: surveys(:survey_1).id, reset_survey: true

    assert_response 302
    assert_equal users(:has_completed_survey).complete_surveys.length, 1

  end

  test "Answer Session should be created only **after** user has progressed to the first question." do
    login(users(:social))

    get :intro, survey_id: surveys(:survey_1).id

    refute assigns(:answer_session)
    refute AnswerSession.most_recent(surveys(:survey_1), users(:social))

    get :start_survey, survey_id: surveys(:survey_1).id

    assert_redirected_to ask_question_path(question_id: surveys(:survey_1).first_question_id, answer_session_id: AnswerSession.most_recent(surveys(:survey_1).id, users(:social).id).id)
    assert AnswerSession.most_recent(surveys(:survey_1), users(:social))

  end
end
