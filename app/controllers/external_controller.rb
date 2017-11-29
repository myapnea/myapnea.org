# frozen_string_literal: true

# Displays publicly available pages.
class ExternalController < ApplicationController
  # # GET /community
  # def community
  # end

  # # GET /consent
  # def consent
  # end

  # # GET /contact
  # def contact
  # end

  # # GET /faqs
  # def faqs
  # end

  def landing
    redirect_to landing6_path
  end

  # # GET /landing6
  def landing6
    render layout: "layouts/full_page_custom_header"
  end

  # # POST /preview
  # def preview
  # end

  # # GET /privacy_policy
  # def privacy_policy
  # end

  def sitemap
    sitemap_xml = File.join(CarrierWave::Uploader::Base.root, "sitemaps", "sitemap.xml.gz")
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

  # # GET /voting
  # def voting
  # end
end
