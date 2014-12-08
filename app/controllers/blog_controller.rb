class BlogController < ApplicationController
  before_action :authenticate_user!, :only => [:new] #add authentication here where needed
  before_action :set_active_top_nav_link_to_blog

  layout 'main'

  def blog
    # TODO: Refactor into models (fb posts and forum posts are types of posts)

    @active_top_nav_link = "blog"

    @posts = Post.all_posts(false)



=begin
Type
  - facebook
  - forem
  - *blog
  - *notification
User Photo
  - fb: AASA profile pic
  - forum: user photo
Title (linked)
  - fb: name/link keys
  - forum: topic title/link to topic page
User Name
  - fb: ASAA on Facebook
  - forum: user's social profile name
Date Created:
  - fb: 'created_time' ==> Time.zone.parse
  - forum: Topic's created at
Content:
  - fb: picture followed by description

FB Specific:
  - caption: show under linked title to highlight source of article

     user photo
      # AASA facebook photo for FB
      # User photo for forums
    # Title (linked)
      # name/link combo for FB
      # Topic title + link to topic page for forums

=end



  end



end