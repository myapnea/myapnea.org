require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "#unlock_survey" do
    u = users(:has_completed_survey)
    as = answer_sessions(:complete)
    encounter = as.encounter
    survey_slug = as.survey.slug

    as.lock

    assert as.completed?
    assert as.locked?

    assert_not_nil u.unlock_survey!(survey_slug, encounter)

    as.reload
    refute as.locked?
    refute as.completed?
  end


  test "#report_value" do
    # For questions with answer option templates, return the value of the answer option
    assert_equal "2", users(:social).report_value({survey_slug: 'for-reports', question_slug: 'country', encounter: 'baseline', answer_template_name: 'countries'})
    assert_equal "2", users(:social).report_value({survey_slug: 'for-reports', question_slug: 'country', encounter: 'baseline'})
    assert_equal "3", users(:participant).report_value({survey_slug: 'for-reports', question_slug: 'country', encounter: 'baseline', answer_template_name: 'countries'})
    assert_equal "3", users(:participant).report_value({survey_slug: 'for-reports', question_slug: 'country', encounter: 'baseline'})

    # For questions with no answer option template, return their value
    assert_equal "Easter Island", users(:participant).report_value({survey_slug: 'for-reports', question_slug: 'country', encounter: 'baseline', answer_template_name: 'spec_countries'})

    # Return array of values if multiple values are allowed (checkbox)
    multiple_values = users(:has_completed_survey).report_value({survey_slug: 'new-survey', question_slug: 'race-selection', encounter: 'baseline', answer_template_name: 'fixture_race'})
    assert multiple_values.kind_of?(Array)
    assert_includes multiple_values, "2"
    assert_includes multiple_values, "5"

    # Return nil if answer does not exist
    assert_nil users(:has_incomplete_survey).report_value({survey_slug: '', question_slug: 'country', encounter: 'baseline'})
  end
end
