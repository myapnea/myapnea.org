# frozen_string_literal: true

# Displays publicly available pages
class ExternalController < ApplicationController
  layout 'application-padded'

  def contact
    render layout: 'simple'
  end

  def landing
    render layout: 'full_page_no_header'
  end

  # def preview
  # end

  # GET /community
  # def community
  # end

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
