require "test_helper"

class UserMailerTest < ActionMailer::TestCase

  test "forum digest email" do
    valid = users(:user_1)

    email = UserMailer.forum_digest(valid).deliver_now
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal [valid.email], email.to
    assert_equal "Forum Digest for #{Date.today.strftime('%a %d %b %Y')}", email.subject
    assert_match(/Dear #{valid.first_name},/, email.encoded)
  end

  test "post approved email" do
    post = posts(:two)
    moderator = users(:moderator_1)

    # Send the email, then test that it got queued
    email = UserMailer.post_approved(post, moderator).deliver_now
    assert !ActionMailer::Base.deliveries.empty?

    # Test the body of the sent email contains what we expect it to
    assert_equal [post.user.email], email.to
    assert_equal "Forum Post Approved: #{post.topic.name}", email.subject
    assert_match(/Your forum post has been approved\./, email.encoded)
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
    assert_match(/Your registration with MyApnea\.Org was successful\. Thank you for joining our growing network!/, email.encoded)
  end


end
