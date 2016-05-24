# frozen_string_literal: true

# To run task
# bundle exec rake sitemap:refresh:no_ping
# Or production
# bundle exec rake sitemap:refresh RAILS_ENV=production
# https://www.google.com/webmasters/tools/

require 'rubygems'
require 'sitemap_generator'

SitemapGenerator.verbose = false
SitemapGenerator::Sitemap.default_host = 'https://myapnea.org'
SitemapGenerator::Sitemap.sitemaps_host = ENV['website_url']
SitemapGenerator::Sitemap.public_path = 'carrierwave/'
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.create do
  add '/landing', changefreq: 'daily', priority: 0.7
  add '/blog', changefreq: 'daily', priority: 0.9
  add '/forum', changefreq: 'daily', priority: 0.8
  add '/about', changefreq: 'weekly', priority: 0.7
  add '/team', changefreq: 'monthly', priority: 0.51
  add '/learn', changefreq: 'weekly', priority: 0.51
  add '/faqs', changefreq: 'monthly', priority: 0.51
  add '/partners', changefreq: 'monthly', priority: 0.3
  add '/contact', changefreq: 'monthly', priority: 0.3

  Broadcast.published.find_each do |broadcast|
    add "/blog/#{broadcast.to_param}", lastmod: broadcast.updated_at
  end
  Chapter.current.find_each do |chapter|
    add "/forum/#{chapter.to_param}", lastmod: chapter.updated_at
    if chapter.last_page > 1
      (2..chapter.last_page).each do |page|
        add "/forum/#{chapter.to_param}/#{page}", lastmod: chapter.updated_at
      end
    end
  end
  add '/surveys', changefreq: 'weekly', priority: 0.8
  Survey.viewable.find_each do |survey|
    add "/surveys/#{survey.to_param}", lastmod: survey.updated_at
  end
  add '/providers', changefreq: 'monthly', priority: 0.6
end
