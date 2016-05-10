# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/invite_mailer
class InviteMailerPreview < ActionMailer::Preview

  def new_member_invite
    invite = Invite.first
    user = User.first
    InviteMailer.new_member_invite(invite, user)
  end

  def new_provider_invite
    invite = Invite.second
    user = User.first
    InviteMailer.new_provider_invite(invite, user)
  end


end
