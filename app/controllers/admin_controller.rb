# frozen_string_literal: true

# Allows admins to view admin dashboard and reports.
class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin_or_moderator_or_report_manager

  layout "layouts/full_page_sidebar"

  # GET /admin
  # def dashboard
  # end

  # GET /admin/spam-inbox
  def spam_inbox
    @spammers = spammers
  end

  # POST /admin/unspamban/:id
  def unspamban
    member = spammers.find_by(id: params[:id])
    if member
      member.update(spammer: false)
      flash[:notice] = "Member marked as not a spammer. You may still need to unshadow ban them."
    end
    redirect_to admin_spam_inbox_path
  end

  # POST /admin/empty-spam/:id
  def destroy_spammer
    @spammer = spammers.find_by(id: params[:id])
    return unless @spammer
    @spammer.topics.destroy_all
    Notification.where(reply: @spammer.replies).destroy_all
    @spammer.update(spammer: true)
    @spammer.destroy
    @spammers = spammers
  end

  # POST /admin/empty-spam
  def empty_spam
    Topic.current.where(user: spammers).destroy_all
    Notification.where(reply: Reply.where(user: spammers)).destroy_all
    spammers.update_all(spammer: true)
    spammers.destroy_all
    redirect_to admin_spam_inbox_path, notice: "All spammers have been deleted."
  end

  private

  def spammers
    User.current.where(shadow_banned: true, spammer: [nil, true])
  end

  def check_admin_or_moderator_or_report_manager
    return if current_user && (current_user.admin? || current_user.moderator? || current_user.report_manager?)
    redirect_to root_path, alert: "You do not have sufficient privileges to access that page."
  end
end
