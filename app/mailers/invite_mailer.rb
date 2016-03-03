# frozen_string_literal: true

# Sends invitation emails
class InviteMailer < ApplicationMailer
  def new_member_invite(invite, user)
    setup_email
    @token = invite.token
    @user = user
    @email_to = invite.email
    @custom_url = "#{ENV['website_url']}?invite_token=#{@token}"
    mail(to: @email_to, subject: "You're Invited to Join MyApnea.Org!")
  end

  def new_provider_invite(invite, user)
    setup_email
    @token = invite.token
    @user = user
    @email_to = invite.email
    @custom_url = "#{ENV['website_url']}/providers/new?invite_token=#{@token}"
    mail(to: @email_to, subject: 'One of your patients has invited you to Join MyApnea.Org!')
  end
end
