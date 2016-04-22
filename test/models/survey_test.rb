# frozen_string_literal: true

require 'test_helper'

class SurveyTest < ActiveSupport::TestCase
  # Loading from file will be deprecated
  test 'should read certain attributes of a survey' do
    survey = surveys(:about_me)
    assert_not_nil survey
    assert_equal 'about-me', survey.slug
    assert_equal 4, survey.questions.count
    assert_match /What is your date of birth?/, survey.questions.first.text
    race = survey.questions.where(slug: 'race').first
    assert race
    assert_equal 2, race.answer_templates.count
    assert_match /American Indian or Alaskan Native/, race.answer_templates.first.answer_options.first.text
    assert_equal 'A', race.answer_templates.first.answer_options.first.hotkey
    assert_equal 1, race.answer_templates.first.answer_options.first.value
    assert_equal 6, race.answer_templates.last.parent_answer_option_value
    assert_equal 2, race.answer_templates.count
  end

  test 'should launch a single survey with an encounter for a user' do
    u = users(:blank_slate)
    assert_empty u.answer_sessions
    assert_difference 'u.answer_sessions.count' do
      surveys(:new).launch_single(u, 'baseline')
    end
    assert_equal surveys(:new), u.answer_sessions.last.survey
  end

  test 'should launch encounter for users created 10 or more days ago' do
    survey_encounter = survey_encounters(:web_encounter_10day)
    survey = survey_encounter.survey

    user = users(:created_today)
    assert_difference 'AnswerSession.count', 0 do
      assert_equal false, survey.launch_encounter_for_user(user, survey_encounter)
    end

    user = users(:created_five_days_ago)
    assert_difference 'AnswerSession.count', 0 do
      assert_equal false, survey.launch_encounter_for_user(user, survey_encounter)
    end

    user = users(:created_fourteen_days_ago)
    assert_difference 'AnswerSession.count' do
      assert_equal true, survey.launch_encounter_for_user(user, survey_encounter)
    end
  end

  test 'should not launch dependent encounter for users who do not have the dependent encounter completed and locked' do
    survey_encounter = survey_encounters(:web_encounter_10day_dependent)
    survey = survey_encounter.survey

    user = users(:created_today)
    assert_difference 'AnswerSession.count', 0 do
      assert_equal false, survey.launch_encounter_for_user(user, survey_encounter)
    end

    user = users(:created_five_days_ago)
    assert_difference 'AnswerSession.count', 0 do
      assert_equal false, survey.launch_encounter_for_user(user, survey_encounter)
    end

    user = users(:created_fourteen_days_ago)
    assert_difference 'AnswerSession.count', 0 do
      assert_equal false, survey.launch_encounter_for_user(user, survey_encounter)
    end
  end

  test 'should launch dependent encounter for user with completed and locked baseline 10 or more days ago' do
    survey_encounter = survey_encounters(:web_encounter_10day_dependent)
    survey = survey_encounter.survey

    user = users(:created_today_with_locked_baseline)
    assert_difference 'AnswerSession.count', 0 do
      assert_equal false, survey.launch_encounter_for_user(user, survey_encounter)
    end

    user = users(:created_five_days_ago_with_locked_baseline)
    assert_difference 'AnswerSession.count', 0 do
      assert_equal false, survey.launch_encounter_for_user(user, survey_encounter)
    end

    user = users(:created_fourteen_days_ago_with_locked_baseline)
    assert_difference 'AnswerSession.count' do
      assert_equal true, survey.launch_encounter_for_user(user, survey_encounter)
    end
  end

  test 'should launch followup surveys' do
    assert_equal true, Survey.launch_followup_encounters
  end
end
