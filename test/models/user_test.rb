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
end
