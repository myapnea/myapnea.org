# frozen_string_literal: true

# To run task
# rails sitemap:refresh:no_ping
# Or production
# rails sitemap:refresh RAILS_ENV=production
# https://www.google.com/webmasters/tools/

require "rubygems"
require "sitemap_generator"

SitemapGenerator.verbose = false
SitemapGenerator::Sitemap.default_host = "https://myapnea.org"
SitemapGenerator::Sitemap.sitemaps_host = ENV["website_url"]
SitemapGenerator::Sitemap.public_path = "carrierwave/sitemaps/"
SitemapGenerator::Sitemap.sitemaps_path = ""
SitemapGenerator::Sitemap.create do
  add "/landing", changefreq: "daily", priority: 0.7
  add "/blog", changefreq: "daily", priority: 0.9
  add "/forum", changefreq: "daily", priority: 0.8
  add "/research", changefreq: "daily", priority: 0.8
  add "/about", changefreq: "weekly", priority: 0.7
  add "/team", changefreq: "monthly", priority: 0.51
  add "/education", changefreq: "weekly", priority: 0.51
  add "/faqs", changefreq: "monthly", priority: 0.51
  add "/partners", changefreq: "monthly", priority: 0.3
  add "/contact", changefreq: "monthly", priority: 0.3
  add "/privacy-policy", changefreq: "monthly", priority: 0.3
  add "/terms-and-conditions", changefreq: "monthly", priority: 0.3
  add "/terms-of-access", changefreq: "monthly", priority: 0.3
  Broadcast.published.joins(:category).merge(Admin::Category.current.where(show_on_blog_roll: true)).find_each do |broadcast|
    add "/blog/#{broadcast.to_param}", lastmod: broadcast.updated_at
  end
  Broadcast.published.joins(:category).merge(Admin::Category.current.where(show_on_blog_roll: false)).find_each do |broadcast|
    add "/articles/#{broadcast.to_param}", lastmod: broadcast.updated_at
  end
  Topic.current.find_each do |topic|
    add "/forum/#{topic.to_param}", lastmod: topic.updated_at
    if topic.last_page > 1
      (2..topic.last_page).each do |page|
        add "/forum/#{topic.to_param}/#{page}", lastmod: topic.updated_at
      end
    end
  end
end
