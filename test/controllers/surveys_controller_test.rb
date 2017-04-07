# frozen_string_literal: true

require 'test_helper.rb'

# Tests to assure that surveys can be completed.
class SurveysControllerTest < ActionController::TestCase
  test 'should get index for logged out user' do
    get :index
    assert_not_nil assigns(:surveys)
    assert_response :success
  end

  test 'should get index for regular user' do
    login(users(:has_launched_survey))
    get :index
    assert_not_nil assigns(:surveys)
    assert_not_nil assigns(:answer_sessions)
    assert_response :success
  end

  test 'should get index for user assigned a blank survey' do
    login(users(:adult_diagnosed))
    get :index
    assert_not_nil assigns(:answer_sessions)
    assert_response :success
  end

  test 'should not get survey for logged out user' do
    get :show, params: { id: surveys(:new) }
    assert_redirected_to new_user_session_path
  end

  ## Assigned Surveys
  test 'should show survey for regular user' do
    login(users(:has_launched_survey))
    get :show, params: { id: answer_sessions(:launched).survey }
    assert_response :success
  end

  test 'should show survey that has no questions' do
    login(users(:participant))
    get :show, params: { id: answer_sessions(:without_questions_participant_baseline).survey, encounter: answer_sessions(:without_questions_participant_baseline).encounter }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:answer_session)
    assert_equal 0, assigns(:survey).questions.count
    assert_response :success
  end

  test 'should show survey that has questions without answer templates' do
    login(users(:participant))
    get :show, params: { id: answer_sessions(:without_answer_templates_participant_baseline).survey, encounter: answer_sessions(:without_answer_templates_participant_baseline).encounter }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:answer_session)
    assert_equal 0, assigns(:survey).questions.first.answer_templates.count
    assert_response :success
  end

  test 'should show baseline survey for regular user without encounter specified' do
    login(users(:has_incomplete_survey))
    get :show, params: { id: surveys(:new_2) }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:answer_session)
    assert_equal answer_sessions(:incomplete2_baseline), assigns(:answer_session)
    assert_response :success
  end

  test 'should show baseline survey for regular user with encounter specified' do
    login(users(:has_incomplete_survey))
    get :show, params: { id: surveys(:new_2), encounter: 'baseline' }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:answer_session)
    assert_equal answer_sessions(:incomplete2_baseline), assigns(:answer_session)
    assert_response :success
  end

  test 'should show followup survey for regular user' do
    login(users(:has_incomplete_survey))
    get :show, params: { id: surveys(:new_2), encounter: 'followup' }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:answer_session)
    assert_equal answer_sessions(:incomplete2_followup), assigns(:answer_session)
    assert_response :success
  end

  test 'should not show survey and get accept update first for user who has not accepted recent update' do
    login(users(:social))
    get :show, params: { id: surveys(:new), encounter: 'followup' }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:answer_session)
    assert_redirected_to accept_update_first_survey_path(assigns(:survey), assigns(:answer_session).encounter)
  end

  test 'should not show child survey and get accept update first for user who has not accepted recent update' do
    login(users(:social))
    get :show, params: { id: surveys(:new), encounter: 'followup', child_id: children(:three) }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:answer_session)
    assert_not_nil assigns(:answer_session).child
    assert_redirected_to accept_update_first_survey_path(assigns(:survey), assigns(:answer_session).encounter, assigns(:answer_session).child_id)
  end

  test 'should get accept update' do
    login(users(:social))
    get :accept_update_first, params: { id: surveys(:new), encounter: 'followup' }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:answer_session)
    assert_response :success
  end

  test 'should get accept update and redirect to survey if recently accepted' do
    login(users(:social))
    users(:social).update accepted_update_at: Date.parse(User::RECENT_UPDATE_DATE).end_of_day
    get :accept_update_first, params: { id: surveys(:new), encounter: 'followup' }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:answer_session)
    assert_redirected_to show_survey_path(assigns(:survey), assigns(:answer_session).encounter)
  end

  test 'should get accept update for child survey' do
    login(users(:social))
    get :accept_update_first, params: { id: surveys(:new), encounter: 'followup', child_id: children(:three) }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:answer_session)
    assert_not_nil assigns(:answer_session).child
    assert_response :success
  end

  test 'should get accept update and redirect to survey if recently accepted for child survey' do
    login(users(:social))
    users(:social).update accepted_update_at: Date.parse(User::RECENT_UPDATE_DATE).end_of_day
    get :accept_update_first, params: { id: surveys(:new), encounter: 'followup', child_id: children(:three) }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:answer_session)
    assert_not_nil assigns(:answer_session).child
    assert_redirected_to child_survey_path(assigns(:answer_session).child.id, assigns(:answer_session).survey, assigns(:answer_session).encounter)
  end

  test 'User can answer question on an assigned survey' do
    login(users(:has_incomplete_survey))
    refute answer_sessions(:incomplete).completed?
    post :process_answer, params: { question_id: questions(:checkbox1), answer_session_id: answer_sessions(:incomplete), response: { answer_templates(:race_list).to_param => [answer_options(:wookie).id.to_s, answer_options(:other_race).id.to_s], answer_templates(:fixture_specified_race).to_param => 'Polish'} }, format: 'json'
    assert_not_nil assigns(:answer)
    assert assigns(:answer).persisted?
    assert assigns(:answer).completed?
    refute assigns(:answer).validation_errors.present?
    refute assigns(:answer).locked?
    assert_equal answer_options(:wookie).id, assigns(:answer).answer_values.first.answer_option_id
    assert_equal 3, assigns(:answer).answer_values.count
    assert_equal 'Wookie', assigns(:answer).answer_values.first.answer_option.text
    assert_equal 'Some other race', assigns(:answer).answer_values.second.answer_option.text
    assert_equal 'Polish', assigns(:answer).answer_values.last.text_value
    assert_equal 2, assigns(:answer_session).answers.complete.count, "#{assigns(:answer_session).survey.questions.count} #{assigns(:answer_session).answers.to_a}"
    assert_response :success
  end

  test 'should process answer for date question' do
    login(users(:has_incomplete_survey))
    post :process_answer, params: { question_id: questions(:date1), answer_session_id: answer_sessions(:incomplete2_followup), response: { answer_templates(:custom_date_template).to_param => { month: '3', day: '12', year: '1920' } } }, format: 'json'
    assert_not_nil assigns(:answer)
    assert assigns(:answer).persisted?
    assert assigns(:answer).completed?
    refute assigns(:answer).validation_errors.present?
    refute assigns(:answer).locked?
    assert_equal 1, assigns(:answer).answer_values.count
    assert_equal '03/12/1920', assigns(:answer).value[questions(:date1).answer_templates.first.id]
    assert_equal 1, assigns(:answer_session).answers.complete.count, "#{assigns(:answer_session).survey.questions.count} #{assigns(:answer_session).answers.to_a}"
    assert_response :success
  end

  test 'User can remove all answers from a checkbox question' do
    login(users(:has_incomplete_survey))
    refute answer_sessions(:incomplete).completed?
    post :process_answer, params: { question_id: questions(:checkbox1), answer_session_id: answer_sessions(:incomplete) }, format: 'json'
    assert_response :success
    assert_not_nil assigns(:answer)
    assert assigns(:answer).persisted?
    refute assigns(:answer).completed?
    refute assigns(:answer).locked?
    assert_equal 1, assigns(:answer_session).answers.complete.count, "#{assigns(:answer_session).survey.questions.count} #{assigns(:answer_session).answers.to_a}"
  end

  test 'User can prefer not to answer a question on an assigned survey' do
    login(users(:has_incomplete_survey))
    refute answer_sessions(:incomplete).completed?
    post :process_answer, params: { question_id: questions(:checkbox1), answer_session_id: answer_sessions(:incomplete), response: { preferred_not_to_answer: '1' } }, format: 'json'
    assert_not_nil assigns(:answer)
    assert assigns(:answer).persisted?
    assert assigns(:answer).completed?
    assert assigns(:answer).preferred_not_to_answer?
    assert_equal 2, assigns(:answer_session).answers.complete.count, "#{assigns(:answer_session).survey.questions.count} #{assigns(:answer_session).answers.to_a}"
    assert_response :success
  end

  test 'should not process answer without valid question' do
    login(users(:has_incomplete_survey))
    post :process_answer, params: { question_id: nil, answer_session_id: answer_sessions(:incomplete), response: { } }, format: 'json'

    assert_not_nil assigns(:answer_session)
    assert_nil assigns(:question)
    assert_response :no_content
  end

  test 'should get report for user with a locked survey' do
    login(users(:has_completed_survey))
    # TODO: Add fixtures to actually complete the users survey
    # assert answer_sessions(:complete_about_me).completed?
    get :report, params: { id: answer_sessions(:complete_about_me).survey }
    assert_not_nil assigns(:answer_session)
    assert_response :success
  end

  test 'should get details report for user with a locked survey' do
    login(users(:has_completed_survey))
    assert answer_sessions(:complete).completed?
    get :report_detail, params: { id: answer_sessions(:complete).survey }
    assert_not_nil assigns(:answer_session)
    assert_response :success
  end

  test 'should get standard survey report for web built surveys for user with completed survey' do
    login(users(:has_completed_survey))
    get :report, params: { id: answer_sessions(:complete).survey }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:answer_session)
    assert_redirected_to report_detail_survey_path(answer_sessions(:complete).survey, answer_sessions(:complete).encounter)
  end

  test 'should get standard survey report for web built surveys for researcher' do
    login(users(:researcher))
    get :report, params: { id: surveys(:new) }
    assert_not_nil assigns(:survey)
    assert_nil assigns(:answer_session)
    assert_redirected_to report_detail_survey_path(assigns(:survey), 'baseline')
  end

  test 'should get standard survey report for web built surveys for caregivers of children' do
    login(users(:social))
    get :report, params: { id: answer_sessions(:completed_survey_child_for_child).survey, child_id: children(:three), encounter: answer_sessions(:completed_survey_child_for_child).encounter }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:answer_session)
    assert_redirected_to child_survey_report_detail_path(assigns(:answer_session).child.id, assigns(:answer_session).survey, assigns(:answer_session).encounter)
  end

  ## Unassigned Surveys

  test 'should not show survey to user who has not been assigned the survey' do
    login(users(:social))
    get :show, params: { id: surveys(:new) }
    assert_redirected_to surveys_path
  end

  ## Incomplete Survey

  test 'should not get report for user with an unstarted survey' do
    login(users(:has_launched_survey))
    get :report, params: { id: answer_sessions(:launched).survey }
    assert_not_nil assigns(:answer_session)
    assert_redirected_to show_survey_path(assigns(:answer_session).survey, assigns(:answer_session).encounter)
  end

  test 'should not get report for user with an incomplete survey' do
    login(users(:has_incomplete_survey))
    get :report, params: { id: answer_sessions(:incomplete).survey }
    assert_not_nil assigns(:answer_session)
    assert_redirected_to show_survey_path(assigns(:answer_session).survey, assigns(:answer_session).encounter)
  end

  test 'should not get report for user who is not assigned and is not a researcher' do
    login(users(:participant))
    get :report, params: { id: surveys(:new) }
    assert_nil assigns(:answer_session)
    assert_redirected_to surveys_path
  end

  test 'should not get report for user with an incomplete child survey' do
    login(users(:social))
    get :report, params: { id: answer_sessions(:must_accept_update_first_for_child).survey, encounter: answer_sessions(:must_accept_update_first_for_child).encounter, child_id: answer_sessions(:must_accept_update_first_for_child).child_id }
    assert_not_nil assigns(:answer_session)
    assert_not_nil assigns(:answer_session).child
    assert_redirected_to child_survey_path(assigns(:answer_session).child.id, assigns(:answer_session).survey, assigns(:answer_session).encounter)
  end

  ## Complete Surveys
  test 'should get completed survey for user' do
    login(users(:has_completed_survey))
    assert answer_sessions(:complete).completed?
    get :show, params: { id: surveys(:new) }
    assert_not_nil assigns(:survey)
    assert_not_nil assigns(:answer_session)
    assert_response :success
  end

  ## Survey Submition
  test 'User can submit survey, locking all completed answers' do
    login(users(:has_completed_survey))
    assert answer_sessions(:complete).completed?
    post :submit, params: { answer_session_id: answer_sessions(:complete).id }, format: 'json'
    answer_sessions(:complete).answers.each do |answer|
      assert answer.locked?
      old_val = answer.value
      answer.update_response_value!(nil)
      assert old_val, answer.value
    end
  end

  test 'should not submit and lock survey with invalid answer session' do
    login(users(:has_completed_survey))
    post :submit, params: { answer_session_id: -1 }, format: 'json'
    assert_nil assigns(:answer_session)
    assert_response :no_content
  end

  ## Academic Users
  test 'Researcher can view survey report without completed answer session' do
    u = users(:researcher)
    login(u)
    assert u.is_only_researcher?
    assert u.ready_for_research?
    get :report_detail, params: { id: surveys(:new) }
    assert_template :report_detail
    assert_response :success
  end

  test 'should get report for researcher without a completed answer session' do
    u = users(:researcher)
    login(u)
    assert u.is_only_researcher?
    assert u.ready_for_research?
    get :report, params: { id: surveys(:about_me) }
    assert_response :success
  end
end
