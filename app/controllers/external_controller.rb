# frozen_string_literal: true

# Displays publicly available pages.
class ExternalController < ApplicationController
  # GET /about
  def about
    render layout: "layouts/full_page"
  end

  # TODO: Make this direct to MyApnea Core consent.
  # # GET /consent
  # def consent
  # end

  # # GET /contact
  # def contact
  # end

  # GET /
  # GET /landing
  def landing
    render layout: "layouts/full_page"
  end

  # GET /partners
  def partners
    @partners = Admin::Partner.current.where(displayed: true).order(:position)
  end

  # # POST /preview
  # def preview
  # end

  def sitemap
    sitemap_xml = File.join(CarrierWave::Uploader::Base.root, "sitemaps", "sitemap.xml.gz")
    if File.exist?(sitemap_xml)
      send_file sitemap_xml
    else
      head :ok
    end
  end

  # GET /team
  def team
    @team_members = Admin::TeamMember.current.order(:position)
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

  # GET /version
  # GET /version.json
  def version
    render layout: "layouts/full_page"
  end
end
