# frozen_string_literal: true

class MembersController < ApplicationController
  before_action :find_member_or_redirect, only: [:show]

  def index
    redirect_to chapters_path
  end

  def show
    @replies = @member.replies.order(id: :desc).page(params[:page]).per(20)
  end

  # GET /search.json?q=QUERY
  def search
    render json: member_scope.where('users.forum_name ~* ?', "(\\m#{params[:q].to_s.gsub(/[^a-zA-Z0-9]/, '')})").limit(10).pluck(:forum_name)
  end

  private

  def find_member_or_redirect
    @member = User.current.where('LOWER(users.forum_name) = ?', params[:forum_name].to_s.downcase).first
    redirect_without_member
  end

  def redirect_without_member
    empty_response_or_root_path(members_path) unless @member
  end

  def member_scope
    User.current.where('users.id IN (SELECT replies.user_id FROM replies WHERE replies.deleted = ?)', false).where.not(forum_name: [nil, '']).order("LOWER(forum_name)")
  end
end
