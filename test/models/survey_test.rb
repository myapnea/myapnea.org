require "test_helper"

class SurveyTest < ActiveSupport::TestCase

  test "#self.load_from_file" do
    assert_difference "Survey.count" do
      Survey.load_from_file("about-me")
    end

    survey = Survey.find_by_name_en("About Me")

    assert_not_nil survey

    assert_equal "about-me", survey.slug
    assert_equal 5, survey.all_questions_descendants.length

    assert_match /What is your date of birth?/, survey.all_questions_descendants.first.text

    cb_q = survey.all_questions.where(slug: "race").first

    assert cb_q
    assert_equal 2, cb_q.answer_templates.length
    assert_match /Asian/, cb_q.answer_templates.first.answer_options.first.text
    assert_equal "A", cb_q.answer_templates.first.answer_options.first.hotkey
    assert_equal 1, cb_q.answer_templates.first.answer_options.first.value
  end




end
