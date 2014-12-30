class PostsController < ApplicationController
  authorize_actions_for Post
  before_action :authenticate_user!

  before_action :set_post

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_post @post
    end
  end

  def update
    if @post.update(post_params)
      redirect_post @post
    end
  end

  def edit
  end

  def new
    @post = Post.new
  end

  def destroy
    @post.destroy

    redirect_post @post

  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :post_type, :state, :author, :introduction, tags: [])
  end

  def set_post
    @post = Post.find_by_id(params[:id])
  end

  def redirect_post(post)
    if post.is_notification?
      redirect_to admin_notifications_path
    else
      redirect_to admin_blog_path
    end
  end

  ## TODO: Integrate with next step

  # def receive_update
  #   if @oauth.validate_update(request.body, headers)
  #     File.open(FB_CACHE_LOCATION, mode='rw')
  #     File.write(request.body)
  #
  #     # process update from request.body
  #   else
  #     render text: "not authorized", status: 401
  #   end
  # end
  #
  #
  # def verify_subscription
  #   Koala::Facebook::RealtimeUpdates.meet_challenge(@params, YOUR_VERIFY_TOKEN)
  # end
end
