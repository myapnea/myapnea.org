class ForumsController < ApplicationController

  before_action :authenticate_user!,      only: [:new, :create, :edit, :update, :destroy]
  before_action :check_owner,             only: [:new, :create, :edit, :update, :destroy]

  before_action :set_forum,               only: [:show, :edit, :update, :destroy]
  before_action :redirect_without_forum,  only: [:show, :edit, :update, :destroy]

  respond_to :html

  # TODO remove when new layout is default
  layout 'layouts/cleantheme'

  def index
    @forums = Forum.current
    respond_with(@forums)
  end

  def show
    @forum.increase_views!(current_user)
    respond_with(@forum)
  end

  def new
    @forum = Forum.new
    respond_with(@forum)
  end

  def edit
  end

  def create
    @forum = current_user.forums.new(forum_params)
    flash[:notice] = 'Forum was successfully created.' if @forum.save
    respond_with(@forum)
  end

  def update
    flash[:notice] = 'Forum was successfully updated.' if @forum.update(forum_params)
    respond_with(@forum)
  end

  def destroy
    @forum.destroy
    respond_to do |format|
      format.html { redirect_to forums_path }
      format.json { head :no_content }
    end
  end

  private
    def set_forum
      @forum = Forum.current.find_by_slug(params[:id])
    end

    def redirect_without_forum
      empty_response_or_root_path(forums_path) unless @forum
    end

    def forum_params
      params.require(:forum).permit(:name, :description, :slug, :position)
    end
end
