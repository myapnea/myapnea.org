class BlogController < ApplicationController
  before_action :authenticate_user!, :only => [:new] #add authentication here where needed
  before_action :set_active_top_nav_link_to_blog

  layout 'main'

  def blog
    # TODO: Refactor into models (fb posts and forum posts are types of posts)

    @active_top_nav_link = "blog"
    @posts = []

    # Facebook
    if FB_API
      fb_posts = FB_API.get_connections("sleepapneaassn", "feed", {limit: 15, fields: "id,from,story,picture,link,name,caption,description,icon,created_time"})
      fb_poster =  FB_API.get_object("sleepapneaassn")
      fb_picture = FB_API.get_connections("sleepapneaassn", "picture", {redirect: false})["data"]["url"]

      fb_posts.each do |fb_post|
        @posts << {
            type: :facebook,
            user_photo: fb_picture,
            title: fb_post["name"],
            title_link: fb_post["link"],
            user: fb_poster["name"],
            user_link: fb_poster["link"],
            created_at: Time.zone.parse(fb_post["created_time"]),
            content_picture: fb_post["picture"],
            content_description: fb_post["description"],
            caption: fb_post[:caption]
        }
      end

    end

    # Forem
    news_forem = Forem::Forum.find_by_name("News")
    if news_forem.present?
      forum_posts = news_forum.topics
    end





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