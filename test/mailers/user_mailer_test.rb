# frozen_string_literal: true

require 'test_helper'

# Tests that mail views are rendered correctly, sent to correct user, and have a
# correct subject line.
class UserMailerTest < ActionMailer::TestCase
  test 'welcome email' do
    valid = users(:user_1)
    mail = UserMailer.welcome(valid)
    assert_equal [valid.email], mail.to
    assert_equal 'Welcome to MyApnea.Org!', mail.subject
    assert_match(/Your registration with MyApnea\.Org was successful\./, mail.body.encoded)
  end
end
