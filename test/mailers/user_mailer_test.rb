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

  test 'followup survey email' do
    answer_session = answer_sessions(:incomplete2_followup)
    mail = UserMailer.followup_survey(answer_session)
    assert_equal [users(:has_incomplete_survey).email], mail.to
    assert_equal 'Followup Survey Available on MyApnea.Org!', mail.subject
    assert_match(/You have a new followup survey waiting to be completed on MyApnea\.Org\./, mail.body.encoded)
  end

  test 'new surveys available email' do
    user = users(:has_launched_survey)
    mail = UserMailer.new_surveys_available(user)
    assert_equal [users(:has_launched_survey).email], mail.to
    assert_equal 'New Surveys Available on MyApnea.Org!', mail.subject
    assert_match(/You have new surveys waiting to be completed on MyApnea\.Org\./, mail.body.encoded)
  end

  test 'encounter digest email' do
    admin = users(:admin)
    mail = UserMailer.encounter_digest(admin, 48, {})
    assert_equal [users(:admin).email], mail.to
    assert_equal "48 Followup Surveys Launched on #{Time.zone.today.strftime('%a %d %b %Y')}", mail.subject
    assert_match(/Today, 48 surveys were launched to members of MyApnea\.Org\./, mail.body.encoded)
  end

  test 'export ready email' do
    export = admin_exports(:completed)
    mail = UserMailer.export_ready(export)
    assert_equal [export.user.email], mail.to
    assert_equal "Your Data Export #{export.name} is now Ready", mail.subject
    assert_match(/The data export you requested #{export.name} is now ready for download\./, mail.body.encoded)
  end
end
