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

end
