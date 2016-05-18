# frozen_string_literal: true

# Provides methods to login and register while creating a blog post comment.
class Async::ChapterController < Async::BaseController
  before_action :set_chapter, only: [:login, :reply]
  before_action :set_reply,   only: [:login, :reply]

  def login
    super
    if current_user
      render :create
    else
      render :new
    end
  end

  def register
    super
    render text: 'register'
  end

  def reply
  end

  private

  def set_chapter
    @chapter = Chapter.current.find_by_slug params[:chapter_id]
  end

  def set_reply
    @reply = @chapter.replies.find_by_id params[:reply_id]
    unless @reply
      @reply = @chapter.replies.new(
        reply_id: params[:parent_comment_id] == 'root' ? nil : params[:parent_comment_id]
      )
    end
  end
end
