# frozen_string_literal: true

# Allows admins to view all blog comments in a central location.
class Admin::BroadcastCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_owner

  # GET /admin/blog/comments
  def index
    @order = scrub_order(BroadcastComment, params[:order], 'created_at desc')
    @broadcast_comments = BroadcastComment.includes(:broadcast).order(@order).page(params[:page]).per(40)
  end
end
