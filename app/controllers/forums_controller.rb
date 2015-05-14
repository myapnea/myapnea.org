class ForumsController < ApplicationController

  before_action :authenticate_user!,      only: [:new, :create, :edit, :update, :destroy]
  before_action :check_owner,             only: [:new, :create, :edit, :update, :destroy]

  before_action :set_forum,               only: [:show, :edit, :update, :destroy]
  before_action :redirect_without_forum,  only: [:show, :edit, :update, :destroy]

  before_action :check_approved_terms

  respond_to :html

  def index
    @forums = Forum.current.where.not(slug: ENV['research_topic_forum_slug'])
    respond_with(@forums)
  end

  def show
    @forum.increase_views!(current_user)
    respond_with(@forum)
  end

  def new
    @forum = Forum.new(position: (Forum.count + 1) * 10)
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

    def check_approved_terms
      if current_user and (current_user.accepted_terms_conditions_at.blank? or current_user.accepted_terms_conditions_at < Date.parse(Forum::RECENT_FORUMS_UPDATE_DATE).at_noon)
        session[:return_to] = request.fullpath
        redirect_to terms_and_conditions_path
      end
    end
end
