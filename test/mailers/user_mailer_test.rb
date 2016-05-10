# frozen_string_literal: true

require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  test "forum digest email" do
    valid = users(:user_1)

    email = UserMailer.forum_digest(valid).deliver_now
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal [valid.email], email.to
    assert_equal "Forum Digest for #{Date.today.strftime('%a %d %b %Y')}", email.subject
    assert_match(/Dear #{valid.first_name},/, email.encoded)
  end

  test "post replied email" do
    post = posts(:six)
    user = users(:user_1)

    # Send the email, then test that it got queued
    email = UserMailer.post_replied(post, user).deliver_now
    assert !ActionMailer::Base.deliveries.empty?

    # Test the body of the sent email contains what we expect it to
    assert_equal [user.email], email.to
    assert_equal "New Forum Reply: #{post.topic.name}", email.subject
    assert_match(/Someone posted a reply to the following topic:/, email.encoded)
  end

  test "welcome email" do
    valid = users(:user_1)

    email = UserMailer.welcome(valid).deliver_now
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal [valid.email], email.to
    assert_equal "Welcome to MyApnea.Org!", email.subject
    assert_match(/Your registration with MyApnea\.Org was successful\./, email.encoded)
  end

  test "welcome provider email" do
    provider = users(:provider)

    email = UserMailer.welcome_provider(provider).deliver_now
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal [provider.email], email.to
    assert_equal "MyApnea.Org Provider Registration Information", email.subject
    assert_match(/Thank you for registering as a Provider/, email.encoded)
  end

  test "mentioned in post email" do
    valid = users(:user_1)
    post = posts(:one)

    # Send the email, then test that it got queued
    email = UserMailer.mentioned_in_post(post, valid).deliver_now
    assert !ActionMailer::Base.deliveries.empty?

    # Test the body of the sent email contains what we expect it to
    assert_equal [valid.email], email.to
    assert_equal "#{post.user.forum_name} Mentioned You on the MyApnea Forums", email.subject
    assert_match(/#{post.user.forum_name} mentioned you in a post on the forums at MyApnea.Org\./, email.encoded)
  end

  test "followup survey email" do
    answer_session = answer_sessions(:incomplete2_followup)

    email = UserMailer.followup_survey(answer_session).deliver_now
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal [users(:has_incomplete_survey).email], email.to
    assert_equal "Followup Survey Available on MyApnea.Org!", email.subject
    assert_match(/You have a new followup survey waiting to be completed on MyApnea\.Org\./, email.encoded)
  end

  test "new surveys available email" do
    user = users(:has_launched_survey)

    email = UserMailer.new_surveys_available(user).deliver_now
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal [users(:has_launched_survey).email], email.to
    assert_equal "New Surveys Available on MyApnea.Org!", email.subject
    assert_match(/You have new surveys waiting to be completed on MyApnea\.Org\./, email.encoded)
  end

  test "encounter digest email" do
    owner = users(:owner)

    email = UserMailer.encounter_digest(owner, 48, {}).deliver_now
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal [users(:owner).email], email.to
    assert_equal "48 Followup Surveys Launched on #{Date.today.strftime('%a %d %b %Y')}", email.subject
    assert_match(/Today, 48 surveys were launched to members of MyApnea\.Org\./, email.encoded)
  end

  test 'export ready email' do
    export = admin_exports(:completed)

    email = UserMailer.export_ready(export).deliver_now
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal [export.user.email], email.to
    assert_equal "Your Data Export #{export.name} is now Ready", email.subject
    assert_match(/The data export you requested #{export.name} is now ready for download\./, email.encoded)
  end
end
