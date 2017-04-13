# frozen_string_literal: true

# Displays publicly available pages.
class ExternalController < ApplicationController
  layout 'application_padded'

  # # GET /community
  # def community
  # end

  # # GET /consent
  # def consent
  # end

  # # GET /contact
  # def contact
  # end

  def landing
    render layout: 'full_page_no_header'
  end

  # # POST /preview
  # def preview
  # end

  # # GET /privacy_policy
  # def privacy_policy
  # end

  def sitemap
    sitemap_xml = File.join(CarrierWave::Uploader::Base.root, 'sitemaps', 'sitemap.xml.gz')
    if File.exist?(sitemap_xml)
      send_file sitemap_xml
    else
      head :ok
    end
  end

  # # GET /terms-and-conditions
  # def terms_and_conditions
  # end

  # # GET /terms-of-access
  # def terms_of_access
  # end

  def voting
    render layout: 'simple'
  end
end
