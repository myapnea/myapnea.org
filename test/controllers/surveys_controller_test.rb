require 'test_helper.rb'

class SurveysControllerTest < ActionController::TestCase

  test "should get index for logged out user" do
    get :index
    assert_not_nil assigns(:surveys)
    assert_response :success
  end

  test "should get index for regular user" do
    login(users(:has_launched_survey))
    get :index
    assert_equal 1, assigns(:surveys).count
    assert_equal 1, assigns(:answer_sessions).count
    assert_response :success
  end

  test "should get index for user assigned a blank survey" do
    login(users(:adult_diagnosed))
    get :index
    assert_not_nil assigns(:answer_sessions)
    assert_response :success
  end

  test "should not get survey for logged out user" do
    get :show, id: surveys(:new)
    assert_redirected_to new_user_session_path
  end

  ## Assigned Surveys
  test "should show survey for regular user" do
    login(users(:has_launched_survey))
    get :show, id: answer_sessions(:launched).survey
    assert_response :success
  end

  test "should show survey that has no questions" do
    login(users(:participant))
    get :show, id: answer_sessions(:without_questions_participant_baseline).survey, encounter: answer_sessions(:without_questions_participant_baseline).encounter
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:answer_session)
    assert_equal 0, assigns(:survey).questions.count
    assert_response :success
  end

  test "should show survey that has questions without answer templates" do
    login(users(:participant))
    get :show, id: answer_sessions(:without_answer_templates_participant_baseline).survey, encounter: answer_sessions(:without_answer_templates_participant_baseline).encounter
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:answer_session)
    assert_equal 0, assigns(:survey).questions.first.answer_templates.count
    assert_response :success
  end

  test "should show baseline survey for regular user without encounter specified" do
    login(users(:has_incomplete_survey))
    get :show, id: surveys(:new_2)
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:answer_session)
    assert_equal answer_sessions(:incomplete2_baseline), assigns(:answer_session)
    assert_response :success
  end

  test "should show baseline survey for regular user with encounter specified" do
    login(users(:has_incomplete_survey))
    get :show, id: surveys(:new_2), encounter: 'baseline'
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:answer_session)
    assert_equal answer_sessions(:incomplete2_baseline), assigns(:answer_session)
    assert_response :success
  end

  test "should show followup survey for regular user" do
    login(users(:has_incomplete_survey))
    get :show, id: surveys(:new_2), encounter: 'followup'
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:answer_session)
    assert_equal answer_sessions(:incomplete2_followup), assigns(:answer_session)
    assert_response :success
  end

  test "User can answer question on an assigned survey" do

    login(users(:has_incomplete_survey))

    refute answer_sessions(:incomplete).completed?

    xhr :post, :process_answer, question_id: questions(:checkbox1), answer_session_id: answer_sessions(:incomplete), response: { answer_templates(:race_list).to_param => [answer_options(:wookie).id.to_s, answer_options(:other_race).id.to_s], answer_templates(:fixture_specified_race).to_param => "Polish"}, format: 'json'

    assert_not_nil assigns(:answer)

    assert assigns(:answer).persisted?
    assert assigns(:answer).complete?
    refute assigns(:answer).validation_errors.present?
    refute assigns(:answer).locked?

    assert_equal answer_options(:wookie).id, assigns(:answer).answer_values.first.answer_option_id
    assert_equal 3, assigns(:answer).answer_values.count
    assert_equal "Wookie", assigns(:answer).answer_values.first.answer_option.text
    assert_equal "Some other race", assigns(:answer).answer_values.second.answer_option.text
    assert_equal "Polish", assigns(:answer).answer_values.last.text_value

    assert_equal 2, assigns(:answer_session).answers.complete.count, "#{assigns(:answer_session).survey.questions.count} #{assigns(:answer_session).answers.to_a}"

    assert_response :success
  end

  test "should process answer for date question" do

    login(users(:has_incomplete_survey))

    xhr :post, :process_answer, question_id: questions(:date1), answer_session_id: answer_sessions(:incomplete2_followup), response: { answer_templates(:custom_date_template).to_param => { month: "3", day: "12", year: "1920" } }, format: 'json'
    assert_not_nil assigns(:answer)

    assert assigns(:answer).persisted?
    assert assigns(:answer).complete?
    refute assigns(:answer).validation_errors.present?

    refute assigns(:answer).locked?

    assert_equal 1, assigns(:answer).answer_values.count
    assert_equal "03/12/1920", assigns(:answer).value[questions(:date1).answer_templates.first.id]

    assert_equal 1, assigns(:answer_session).answers.complete.count, "#{assigns(:answer_session).survey.questions.count} #{assigns(:answer_session).answers.to_a}"

    assert_response :success
  end

  test "User can give an invalid answer to a question" do
    login(users(:has_incomplete_survey))

    refute answer_sessions(:incomplete).completed?

    invalid_value = "19999999"
    xhr :post, :process_answer, question_id: questions(:text1), answer_session_id: answer_sessions(:incomplete), response: { answer_templates(:text).to_param => invalid_value }, format: 'json'
    assert_not_nil assigns(:answer)

    assert assigns(:answer).persisted?
    assert assigns(:answer).invalid?
    assert assigns(:answer).validation_errors.present?
    refute assigns(:answer).complete?
    refute assigns(:answer).locked?

    assert_equal 1, assigns(:answer).answer_values.count
    assert_equal invalid_value, assigns(:answer).answer_values.first.text_value

    assert_equal 1, assigns(:answer_session).answers.complete.count

    assert_response :success
  end

  test "User can remove all answers from a checkbox question" do
    login(users(:has_incomplete_survey))

    refute answer_sessions(:incomplete).completed?

    xhr :post, :process_answer, question_id: questions(:checkbox1), answer_session_id: answer_sessions(:incomplete), format: 'json'

    assert_response :success

    assert_not_nil assigns(:answer)

    assert assigns(:answer).persisted?
    refute assigns(:answer).complete?
    refute assigns(:answer).locked?

    assert_equal 1, assigns(:answer_session).answers.complete.count, "#{assigns(:answer_session).survey.questions.count} #{assigns(:answer_session).answers.to_a}"
  end

  test "User can prefer not to answer a question on an assigned survey" do
    login(users(:has_incomplete_survey))

    refute answer_sessions(:incomplete).completed?

    xhr :post, :process_answer, question_id: questions(:checkbox1), answer_session_id: answer_sessions(:incomplete), response: { preferred_not_to_answer: '1' }, format: 'json'
    assert_not_nil assigns(:answer)

    assert assigns(:answer).persisted?
    assert assigns(:answer).complete?
    assert assigns(:answer).preferred_not_to_answer?
    assert_equal 2, assigns(:answer_session).answers.complete.count, "#{assigns(:answer_session).survey.questions.count} #{assigns(:answer_session).answers.to_a}"

    assert_response :success
  end

  test "User can view survey report for completed survey" do
    login(users(:has_completed_survey))

    assert answer_sessions(:complete).completed?

    get :report, id: answer_sessions(:complete).survey

    assert_response :success
  end

  test "User can view detailed survey report for completed survey" do
    login(users(:has_completed_survey))

    assert answer_sessions(:complete).completed?

    get :report_detail, id: answer_sessions(:complete).survey

    assert_response :success
  end

  ## Unassigned Surveys

  test "User cannot view an unassigned survey" do
    login(users(:social))

    get :show, id: surveys(:new)

    assert_redirected_to surveys_path
  end

  ## Incomplete Survey

  test "User cannot view survey report for assigned but unstarted survey" do
    login(users(:has_launched_survey))

    get :report, id: answer_sessions(:launched).survey

    assert_redirected_to surveys_path



  end

  test "User cannot view survey report for incomplete survey" do
    login(users(:has_incomplete_survey))

    get :report, id: answer_sessions(:incomplete).survey

    assert_redirected_to surveys_path
  end


  ## Complete Surveys
  test "should get completed survey for user" do
    login(users(:has_completed_survey))

    assert answer_sessions(:complete).completed?

    get :show, id: surveys(:new)

    assert_not_nil assigns(:survey)

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
      answer.update_response_value!(nil)
      assert old_val, answer.value
    end
  end

  ## Academic Users
  test "Researcher can view survey report without completed answer session" do
    u = users(:researcher)
    login(u)
    assert u.is_only_academic?
    assert u.ready_for_research?

    get :report_detail, id: surveys(:new)

    assert_template :report_detail
    assert_response :success
  end

  test "Researcher can view detailed survey report without completed answer session" do
    u = users(:researcher)
    login(u)
    assert u.is_only_academic?
    assert u.ready_for_research?

    get :report, id: surveys(:new_2)

    assert_response :success
  end


  test "Provider can view survey report without completed answer session" do
    u = users(:provider)
    login(u)
    assert u.is_only_academic?
    assert u.ready_for_research?

    get :report, id: surveys(:new_2)

    assert_response :success

  end

  test "Provider can view detailed survey report without completed answer session" do
    u = users(:provider)
    login(u)
    assert u.is_only_academic?
    assert u.ready_for_research?

    get :report_detail, id: surveys(:new)

    assert_response :success
  end

end
