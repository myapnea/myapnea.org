# frozen_string_literal: true

require 'test_helper'

class InviteMailerTest < ActionMailer::TestCase

  setup do
    @owner = users(:owner)
    @user = users(:user_1)
  end

  test "send invitation email to new member" do
    user = @user
    invite = invites(:one)

    email = InviteMailer.new_member_invite(invite, @user).deliver_now
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal [invite.email], email.to
    assert_equal "You're Invited to Join MyApnea.Org!", email.subject
  end

  test "send invitation email to new provider" do
    user = @user
    invite = invites(:two)

    email = InviteMailer.new_provider_invite(invite, @user).deliver_now
    assert !ActionMailer::Base.deliveries.empty?

    assert_equal [invite.email], email.to
    assert_equal "One of your patients has invited you to Join MyApnea.Org!", email.subject
  end

end
