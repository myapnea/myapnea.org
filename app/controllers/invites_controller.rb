# frozen_string_literal: true

class InvitesController < ApplicationController
  before_action :authenticate_user!

  def members
    @invite = Invite.new
  end

  def providers
    @invite = Invite.new
  end

  def create
    @invite = Invite.where(user_id: current_user.id).new(invite_params)
    if @invite.save
      if @invite.recipient_id.present?
        redirect_to members_invites_path, notice: 'Thank you!'
      elsif @invite.for_provider?
        @invite.send_provider_invite_in_background!
        redirect_to providers_invites_path, notice: 'Thank you!'
      else
        @invite.send_new_member_invite_in_background!
        redirect_to members_invites_path, notice: 'Thank you!'
      end
    end
  end

  private

  def invite_params
    params.require(:invite).permit(:email, :for_provider)
  end
end
