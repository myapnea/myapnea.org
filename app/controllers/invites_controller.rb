class InvitesController < ApplicationController

  before_action :authenticate_user!

  def new
    @invite = Invite.new
  end

  def create
    @invite = Invite.where(user_id: current_user.id).new(invite_params)
    if @invite.save
      if @invite.recipient_id.present?
        redirect_to new_invite_path, warning: 'Thank you, but they have already joined!'
      else
        InviteMailer.new_user_invite(@invite, current_user).deliver_later
        redirect_to new_invite_path, notice: 'Thank you!'
      end
    end
  end

  private

    def invite_params
      params.require(:invite).permit(:email)
    end

end
