class NotificationsController < ApplicationController
  authorize_actions_for Notification
  before_action :authenticate_user!

  before_action :set_notification

  def create
    @notification = current_user.notifications.new(notification_params)

    if @notification.save
      redirect_notification @notification
    end
  end

  def update
    if @notification.update(notification_params)
      redirect_notification @notification
    end
  end

  def edit
  end

  def new
    @notification = Notification.new
  end

  def destroy
    @notification.destroy

    redirect_notification @notification

  end

  private

  def notification_params
    params.require(:notification).permit(:title, :body, :post_type, :state, :author, :introduction, tags: [])
  end

  def set_notification
    @notification = Notification.find_by_id(params[:id])
  end

  def redirect_notification(notification)
    redirect_to admin_notifications_path
  end

  ## TODO: Integrate with next step

  # def receive_update
  #   if @oauth.validate_update(request.body, headers)
  #     File.open(FB_CACHE_LOCATION, mode='rw')
  #     File.write(request.body)
  #
  #     # process update from request.body
  #   else
  #     render text: "not authorized", status: 401
  #   end
  # end
  #
  #
  # def verify_subscription
  #   Koala::Facebook::RealtimeUpdates.meet_challenge(@params, YOUR_VERIFY_TOKEN)
  # end
end
