require "test_helper"

class SurveyTest < ActiveSupport::TestCase

  test "#self.load_from_file" do
    assert_difference "Survey.current" do
      Survey.load_from_file("about-me")
    end

  end




end
