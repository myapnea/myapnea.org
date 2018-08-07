# frozen_string_literal: true

# Displays publicly available pages.
class ExternalController < ApplicationController
  before_action :find_article_or_redirect, only: [:article]

  # GET /about
  def about
    render layout: "layouts/full_page"
  end

  # # GET /articles/:slug
  # def article
  # end

  # POST /articles/:slug/vote
  def article_vote
    @article = Broadcast.current.published.find_by(slug: params[:slug])
    return unless current_user && @article
    @article_vote = @article.article_votes.where(user: current_user).first_or_create
    case params[:vote]
    when "up"
      @article_vote.up_vote!
    when "down"
      @article_vote.down_vote!
    else
      @article_vote.remove_vote!
    end
  end

  # # GET /consent
  # def consent
  # end

  # # GET /contact
  # def contact
  # end

  # GET /
  # GET /landing
  def landing
    topics_to_find = 12
    (1..10).each do |week_number|
      @topics = Topic.current.shadow_banned(nil)
                     .where("topics.created_at > ?", Time.zone.today - week_number.week)
                     .order(replies_count: :desc).limit(topics_to_find)
      break if @topics.count >= topics_to_find
    end
    render layout: "layouts/full_page"
  end

  # GET /partners
  def partners
    @partners = Admin::Partner.current.where(displayed: true).order(:position)
  end

  # # POST /preview
  # def preview
  # end

  # # GET /privacy-policy
  # def privacy_policy
  # end

  # GET /sitemap.xml.gz
  def sitemap_xml
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

  # GET /team/:id/photo
  def team_member_photo
    @admin_team_member = Admin::TeamMember.find_by(id: params[:id])
    send_file_if_present @admin_team_member&.photo
  end

  # GET /partners/:id/photo
  def partner_photo
    @admin_partner = Admin::Partner.find_by(id: params[:id])
    send_file_if_present @admin_partner&.photo
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

  private

  def find_article_or_redirect
    @article = Broadcast.current.published.find_by(slug: params[:slug])
    redirect_to blog_path unless @article
  end
end
