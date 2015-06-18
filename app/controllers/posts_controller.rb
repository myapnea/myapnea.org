class PostsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :edit, :update, :destroy, :preview ]
  before_action :set_active_top_nav_link_to_forums

  before_action :set_forum
  before_action :redirect_without_forum

  before_action :set_topic
  before_action :redirect_without_topic

  before_action :check_approved_terms

  # before_action :check_banned, only: [ :create, :edit, :update ]
  before_action :redirect_on_locked_topic,  only: [ :new, :create, :edit, :update, :destroy ]
  before_action :set_post, only: [ :show ]
  before_action :set_editable_post, only: [ :edit, :update ]
  before_action :set_deletable_post, only: [ :destroy ]
  before_action :redirect_without_post, only: [ :show, :edit, :update, :destroy ]

  before_action :set_SEO_elements

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.where(topic_id: @topic.id).new(post_params)

    respond_to do |format|
      if @post.save
        @post.send_reply_emails!
        @topic.get_or_create_subscription(current_user)
        format.html { redirect_to forum_topic_post_path(@forum, @topic, @post), notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { redirect_to forum_topic_path(@forum, @topic, error: @errors) }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def preview
    @post = current_user.posts.where(topic_id: @topic.id).new(post_params)
  end

  def index
    redirect_to [@forum, @topic]
  end

  def show
    redirect_to forum_topic_path(@forum, @topic, page: @post.page, anchor: @post.anchor)
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to forum_topic_post_path(@forum, @topic, @post), notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to forum_topic_post_path(@forum, @topic, @post), warning: 'Post can\'t be blank.' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy_by_user(current_user)

    respond_to do |format|
      format.html { redirect_to forum_topic_post_path(@forum, @topic, @post), notice: 'Post was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    def set_forum
      @forum = Forum.current.find_by_slug(params[:forum_id])
    end

    def redirect_without_forum
      empty_response_or_root_path(forums_path) unless @forum
    end

    def set_topic
      @topic = @forum.topics.find_by_slug(params[:topic_id])
    end

    def redirect_without_topic
      empty_response_or_root_path(forum_topics_path(@forum)) unless @topic
    end

    def redirect_on_locked_topic
      empty_response_or_root_path(forum_topic_path(@forum, @topic)) if @topic.locked?
    end

    def set_post
      @post = @topic.posts.find_by_id(params[:id])
    end

    def set_editable_post
      @post = current_user.editable_posts.with_unlocked_topic.where(topic_id: @topic.id).find_by_id(params[:id])
    end

    def set_deletable_post
      @post = current_user.deletable_posts.where(topic_id: @topic.id).find_by_id(params[:id])
    end

    def redirect_without_post
      empty_response_or_root_path(forum_topic_path(@forum, @topic)) unless @post
    end

    def post_params
      params[:post] ||= { blank: '1' }

      # Always set post back to pending review if it's updated by a non-moderator
      unless current_user.moderator?
        params[:post][:status] = 'pending_review'
      end

      if current_user.moderator?
        params.require(:post).permit(:description, :status, :links_enabled)
      else
        params.require(:post).permit(:description, :status)
      end
    end

    def check_approved_terms
      if current_user and (current_user.accepted_terms_conditions_at.blank? or current_user.accepted_terms_conditions_at < Date.parse(Forum::RECENT_FORUMS_UPDATE_DATE).at_noon)
        session[:return_to] = request.fullpath
        redirect_to terms_and_conditions_path
      end
    end

    def set_SEO_elements
      @page_title = @post.present? ? @post.description : ('Sleep Apnea Discussion - ' + @topic.name)
      @page_content = 'Sleep apnea forums, discussions about treatments and CPAP machines, sleep deprivation symptoms, and more topics related to sleep apnea discussed on MyApnea.Org'
    end
end
