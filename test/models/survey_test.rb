require "test_helper"

class SurveyTest < ActiveSupport::TestCase

  # Loading from file will be deprecated
  test "should read certain attributes of a survey" do
    survey = Survey.find_by_slug("about-me")
    assert_not_nil survey
    assert_equal "about-me", survey.slug
    assert_equal 4, survey.questions.count
    assert_match /What is your date of birth?/, survey.questions.first.text
    race = survey.questions.where(slug: "race").first
    assert race
    assert_equal 2, race.answer_templates.length
    assert_match /American Indian or Alaskan Native/, race.answer_templates.first.answer_options.first.text
    assert_equal "A", race.answer_templates.first.answer_options.first.hotkey
    assert_equal 1, race.answer_templates.first.answer_options.first.value
    assert_equal 6, race.answer_templates.last.parent_answer_option_value
    assert_equal 2, race.answer_templates.count
  end

  test "should launch a single survey with an encounter for a user" do
    u = users(:blank_slate)
    assert_empty u.assigned_surveys
    assert_difference "u.assigned_surveys.count" do
      result = surveys(:new).launch_single(u, "baseline")
      assert_nil result
    end
    assert_equal surveys(:new), u.assigned_surveys.last
    assert_equal surveys(:new).default_position, u.answer_sessions.last.position
    assert_equal u, surveys(:new).launch_single(u, "baseline")
  end

end
