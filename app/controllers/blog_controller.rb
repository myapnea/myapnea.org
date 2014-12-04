class BlogController < ApplicationController
  before_action :authenticate_user!, :only => [:new] #add authentication here where needed
  before_action :set_active_top_nav_link_to_blog

  layout 'main'

  def blog
    @active_top_nav_link = "blog"
    @fb_posts = FB_API.get_connections("sleepapneaassn", "feed", {limit: 15, fields: "id,from,story,picture,link,name,caption,description,icon,created_time"})

    news_forum = Forem::Forum.find_by_name("News")
    @forum_posts = news_forum.topics if news_forum.present?

    @fb_poster =  FB_API.get_object("sleepapneaassn")
    @fb_picture = FB_API.get_connections("sleepapneaassn", "picture", {redirect: false})["data"]["url"]


    # The general things I need are:

    # user photo
      # AASA facebook photo for FB
      # User photo for forums
    # Title (linked)
      # name/link combo for FB
      # Topic title + link to topic page for forums





  end



end