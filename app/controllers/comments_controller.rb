# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    current_user.comments.where(post_id: @post.id).create(comment_params)
  end

  def destroy
    current_user.comments.find(params[:id]).destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :post_id)
  end

  def set_post
    @post = if params[:action] == 'destroy'
              comment.post
            else
              Post.find_by_id(params[:comment][:post_id])
            end
  end

  def comment
    Comment.current.find_by_id(params[:id])
  end
end
