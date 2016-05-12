# frozen_string_literal: true

# Publicly available and published blog posts
class BlogController < ApplicationController
  before_action :find_broadcast_or_redirect, only: [:show]
  before_action :set_author, only: [:blog]
  before_action :set_category, only: [:blog]

  def blog
    broadcast_scope = Broadcast.current.published.order(publish_date: :desc, id: :desc)
    broadcast_scope = broadcast_scope.where(user: @author) if @author
    broadcast_scope = broadcast_scope.where(category: @category) if @category
    @broadcasts = broadcast_scope.page(params[:page]).per(10)
    respond_to do |format|
      format.html
      format.atom
    end
  end

  def show
    @author = @broadcast.user
  end

  private

  def find_broadcast_or_redirect
    @broadcast = Broadcast.current.published.find_by_slug params[:slug]
    redirect_to blog_path unless @broadcast
  end

  def set_author
    return if params[:author].blank?
    @author = User.current.where('lower(forum_name) = ?', params[:author].downcase).first
  end

  def set_category
    return if params[:category].blank?
    @category = Admin::Category.current.where('lower(slug) = ?', params[:category].downcase).first
  end
end
