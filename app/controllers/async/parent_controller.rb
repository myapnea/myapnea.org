# frozen_string_literal: true

# Provides methods to login while leaving a blog post comment or forum reply.
class Async::ParentController < Async::BaseController
  before_action :find_parent_or_redirect
  before_action :set_reply

  def login
    super
    if current_user
      render :create
    else
      render :new
    end
  end

  # def reply
  # end

  private

  def find_parent_or_redirect
    @chapter = Chapter.current.find_by(slug: params[:chapter_id])
    @broadcast = Broadcast.current.published.find_by(slug: params[:broadcast_id])
    @parent = @chapter || @broadcast
    empty_response_or_root_path unless @parent
  end

  def set_reply
    @reply = @parent.replies.find_by(id: params[:reply_id])
    return if @reply
    @reply = @parent.replies.new(
      reply_id: params[:parent_reply_id] == 'root' ? nil : params[:parent_reply_id]
    )
  end
end
