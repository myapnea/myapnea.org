# frozen_string_literal: true

class MembersController < ApplicationController
  before_action :find_member_or_redirect, only: [:show]

  def index
    redirect_to topics_path
  end

  def show
    @replies = @member.replies.order(created_at: :desc).page(params[:page]).per(20)
  end

  private

  def find_member_or_redirect
    @member = User.current.where('LOWER(users.forum_name) = ?', params[:forum_name].to_s.downcase).first
    redirect_without_member
  end

  def redirect_without_member
    empty_response_or_root_path(members_path) unless @member
  end
end
