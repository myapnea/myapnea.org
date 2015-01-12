class PostsController < ApplicationController
  before_action :authenticate_user!, only: [ :new, :create, :edit, :update, :destroy, :preview ]
  before_action :set_topic, only: [ :show, :destroy ]
  before_action :set_postable_topic, only: [ :create, :edit, :update, :preview ]
  before_action :redirect_without_topic, only: [ :show, :create, :edit, :update, :preview, :destroy ]

  before_action :check_banned, only: [ :create, :edit, :update ]
  before_action :check_last_post_by, only: [ :create ]
  before_action :set_post, only: [ :show ]
  before_action :set_editable_post, only: [ :edit, :update ]
  before_action :set_deletable_post, only: [ :destroy ]
  before_action :redirect_without_post, only: [ :show, :edit, :update, :destroy ]


  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = current_user.posts.where(topic_id: @topic.id).posts.new(post_params)

    respond_to do |format|
      if @post.save
        @topic.get_or_create_subscription(current_user)
        format.html { redirect_to topic_path(@topic) + "#c#{@post.number}", notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { redirect_to topic_path(@topic, error: @errors) }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def preview
    @post = @topic.posts.new(post_params)
  end

  def show
  end

  # PUT /posts/1
  # PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to topic_path(@topic) + "#c#{@post.number}", notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { redirect_to topic_path(@topic) + "#c#{@post.number}", warning: 'Post can\'t be blank.' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy

    respond_to do |format|
      format.html { redirect_to topic_path(@topic) + "#c#{@post.number}" }
      format.json { head :no_content }
    end
  end

  private
    def set_topic
      @topic = Topic.current.find_by_id(params[:topic_id])
    end

    def set_postable_topic
      @topic = Topic.current.where(locked: false).find_by_id(params[:topic_id])
    end

    def redirect_without_topic
      empty_response_or_root_path(topics_path) unless @topic
    end

    def set_post
      @post = Post.current.find_by_id(params[:id])
    end

    def set_editable_post
      @post = current_user.all_posts.with_unlocked_topic.find_by_id(params[:id])
    end

    def set_deletable_post
      @post = current_user.all_posts.find_by_id(params[:id])
    end

    def redirect_without_post
      empty_response_or_root_path( topics_path ) unless @post
    end

    def check_last_post_by
      empty_response_or_root_path( @topic ) if @topic.user_posted_recently?(current_user)
    end

    def post_params
      # params.require(:post).permit(:topic_id, :description, :user_id, :status, :hidden, :deleted, :last_moderated_by_id, :last_moderated_at)
      params.require(:post).permit(:description, :user_id)
    end
end
