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

  private

  def scrub_order(model, params_order, default_order)
    (params_column, params_direction) = params_order.to_s.strip.downcase.split(' ')
    direction = (params_direction == 'desc' ? 'DESC NULLS LAST' : nil)
    column_name = (model.column_names.collect{|c| model.table_name + "." + c}.select{|c| c == params_column}.first)
    order = column_name.blank? ? default_order : [column_name, direction].compact.join(' ')
    order
  end
end
