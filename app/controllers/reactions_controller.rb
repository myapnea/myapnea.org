class ReactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    reaction = current_user.reactions.where(post_id: @post.id).first_or_create
    reaction.update(reaction_params.merge(deleted: false))
  end

  def destroy
    current_user.reactions.find(params[:id]).destroy
  end

  private

  def reaction_params
    params.require(:reaction).permit(:form, :post_id)
  end

  def set_post
    if params[:action] == 'destroy'
      @post = reaction.post
    else
      @post = Post.find_by_id(params[:reaction][:post_id])
    end
  end

  def reaction
    Reaction.current.find_by_id(params[:id])
  end
end
