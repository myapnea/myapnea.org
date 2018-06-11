# frozen_string_literal: true

require "test_helper"

# Tests that mail views are rendered correctly, sent to correct user, and have a
# correct subject line.
class UserMailerTest < ActionMailer::TestCase
  test "welcome email" do
    regular = users(:regular)
    mail = UserMailer.welcome(regular)
    assert_equal [regular.email], mail.to
    assert_equal "Welcome to MyApnea!", mail.subject
    assert_match(/Your registration with MyApnea was successful\./, mail.body.encoded)
  end
end
