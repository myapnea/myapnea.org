# frozen_string_literal: true

# Allows admins to view all forum replies in a central location.
class Admin::RepliesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_owner

  # GET /admin/forum/replies
  def index
    @order = scrub_order(Reply, params[:order], 'created_at desc')
    if ['points', 'points DESC'].include?(params[:order])
      @order = params[:order]
    end
    @replies = Reply.current.points.joins(:chapter).merge(Chapter.current).order(@order).page(params[:page]).per(40)
  end
end
