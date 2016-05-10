# frozen_string_literal: true

require 'rubygems'
require 'sitemap_generator'

SitemapGenerator.verbose = false
SitemapGenerator::Sitemap.default_host = 'http://www.myapnea.org'
SitemapGenerator::Sitemap.sitemaps_host = ENV['website_url']
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.create do
  add '/home', :changefreq => 'daily', :priority => 0.9
  add '/about', :changefreq => 'weekly', :priority => 0.7
  add '/team', :changefreq => 'monthly', :priority => 0.51
  add '/partners', :changefreq => 'monthly', :priority => 0.3
  add '/advisory', :changefreq => 'monthly', :priority => 0.3
  add '/learn', :changefreq => 'weekly', :priority => 0.51
  add '/faqs', :changefreq => 'monthly', :priority => 0.51
  add '/social', :changefreq => 'daily', :priority => 0.6
  add '/forums', :changefreq => 'daily', :priority => 0.8
  Forum.find_each do |forum|
    add '/forums/'+forum.to_param, lastmod: forum.updated_at
  end
  add '/surveys', :changefreq => 'weekly', :priority => 0.8
  Survey.viewable.find_each do |survey|
    add '/surveys/'+survey.to_param, lastmod: survey.updated_at
  end
  add '/research_topics', :changefreq => 'daily', :priority => 0.7
  add '/providers', :changefreq => 'monthly', :priority => 0.6
end
# SitemapGenerator::Sitemap.ping_search_engines # Not needed if you use the rake tasks
