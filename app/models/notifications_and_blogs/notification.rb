class Notification < ActiveRecord::Base
  include Authority::Abilities

  require 'acts-as-taggable-on'
  require "kaminari"

  include ::ActionView::Helpers::TextHelper
  include Deletable

  scope :blog_posts, -> { where(post_type: "blog") }
  scope :notifications, -> { where(post_type: "notification") }
  scope :viewable, -> { where(state: "accepted").order(:created_at) }

  acts_as_taggable

  belongs_to :user
  has_many :votes

  def self.all_posts(short = false)
    posts = Rails.cache.fetch("all_posts", expires_in: 15.minutes) do

      posts = []

      # Facebook
      if FB_API

        self.fb_posts.each do |fb_post|
          unless fb_post["type"] == "status"
            posts << {
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

        posts
      end


      news_forum = Forum.find_by_name("News")
      if news_forum.present?
        topics = news_forum.topics.where(status: 'approved')

        topics.each do |topic|
          if post = topic.posts.where(status: 'approved').first
            posts << {
                type: :forum,
                user_photo: topic.user.photo_url,
                title: topic.name,
                user: topic.user.forum_name,
                user_link: "",
                created_at: topic.created_at,
                content: post.description,
                post: post
            }
          end
        end
      end

      posts.sort! do |a, b|
        b[:created_at] <=> a[:created_at]
      end
    end

    if short
      short_posts = posts[0..2]
      unless short_posts.select {|x| x[:type] == :forum }.present?
        to_replace = posts.find{|x| x[:type] == :forum }
        short_posts[2] = to_replace if to_replace.present?
      end
      posts = short_posts
    end

    posts

  end


  ## Cached API
  def self.fb_posts
    Rails.cache.fetch("facebook/posts", expires_in: 3.hours) do
      FB_API.get_connections("sleepapneaassn", "feed", {limit: 15, fields: "id,from,story,picture,link,name,caption,description,icon,created_time,type"})
    end
  end

  def self.fb_poster
    Rails.cache.fetch("facebook/poster", expires_in: 3.hours) do
      FB_API.get_object("sleepapneaassn")
    end

  end

  def self.fb_picture
    Rails.cache.fetch("facebook/picture", expires_in: 3.hours) do
      FB_API.get_connections("sleepapneaassn", "picture", {redirect: false})["data"]["url"]
    end
  end




  def tags=(val)
    tag_list.add(val)
  end

  def is_notification?
    post_type == "notification"
  end

  def is_blog_post?
    post_type == "blog"
  end

end
