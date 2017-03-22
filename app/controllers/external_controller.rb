# frozen_string_literal: true

# Displays publicly available pages
class ExternalController < ApplicationController
  def contact
    render layout: 'simple'
  end

  def landing
    render layout: 'blank'
  end

  def preview
  end

  def sitemap
    sitemap_xml = File.join(CarrierWave::Uploader::Base.root, 'sitemaps', 'sitemap.xml.gz')
    if File.exist?(sitemap_xml)
      send_file sitemap_xml
    else
      head :ok
    end
  end

  def voting
    render layout: 'simple'
  end
end
