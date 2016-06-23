# frozen_string_literal: true

# Allows users to reply to forum topics.
class RepliesController < ApplicationController
  before_action :authenticate_user!, except: [:vote, :show]
  before_action :find_chapter_or_redirect, except: [:preview, :show]
  before_action :find_viewable_reply_or_redirect, only: [:show]
  before_action :find_editable_reply_or_redirect, only: [:edit, :update, :destroy]

  # # GET /replies
  # def index
  #   @replies = Reply.all
  # end

  # GET /replies/1
  def show
    respond_to do |format|
      format.html do
        redirect_to page_chapter_path(@reply.chapter, page: @reply.page, anchor: @reply.anchor)
      end
      format.js
    end
  end

  def preview
    @reply = current_user.replies.new(reply_params)
  end

  def vote
    @reply = @chapter.replies.find_by_id params[:id]
    redirect_without_reply
    if current_user
      @reply_user = @chapter.reply_users.where(
        user_id: current_user.id, reply: @reply.id
      ).first_or_create
      case params[:vote]
      when 'up'
        @reply_user.up_vote!
      when 'down'
        @reply_user.down_vote!
      else
        @reply_user.remove_vote!
      end
    end
  end

  # # GET /replies/new
  # def new
  #   @reply = Reply.new
  # end

  # GET /replies/1/edit.js
  def edit
  end

  # POST /replies
  def create
    @reply = current_user.replies.where(chapter_id: @chapter.id)
                         .new(reply_params)
    if @reply.save
      @reply.create_notifications!
      @reply.chapter.touch(:last_reply_at)
      current_user.read_chapter!(@chapter, @reply.id)
      render :create
    else
      render :new
    end
  end

  # PATCH /replies/1
  def update
    if @reply.update(reply_params)
      render :show
    else
      render :edit
    end
  end

  # DELETE /replies/1
  def destroy
    @reply.destroy
    render :show
  end

  private

  def find_chapter_or_redirect
    @chapter = Chapter.current.find_by_slug params[:chapter_id]
    redirect_without_chapter
  end

  def redirect_without_chapter
    empty_response_or_root_path(chapters_path) unless @chapter
  end

  def find_viewable_reply_or_redirect
    @reply = Reply.current.find_by_id params[:id]
    redirect_without_reply
  end

  def find_editable_reply_or_redirect
    @reply = current_user.editable_replies.where(chapter_id: @chapter.id).find_by_id params[:id]
    redirect_without_reply
  end

  def redirect_without_reply
    empty_response_or_root_path(@chapter || chapters_path) unless @reply
  end

  def reply_params
    params.require(:reply).permit(:description, :reply_id)
  end
end
