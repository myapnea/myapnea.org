require 'test_helper'

class InviteMailerTest < ActionMailer::TestCase

  setup do
    @owner = users(:owner)
    @user = users(:user_1)
  end

  test "send invitation email" do
    user = @user
    invite = invites(:one)

    email = InviteMailer.new_user_invite(invite, @user).deliver_now
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal [invite.email], email.to
    assert_equal "You're Invited to Join MyApnea.Org!", email.subject
  end

end
