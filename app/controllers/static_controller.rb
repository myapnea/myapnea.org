class StaticController < ApplicationController
  before_action :load_pc, only: [ :team, :advisory, :learn, :research ]
  before_action :about_layout, only: [ :research ]

  ## Static
  def about
  end

  def team
  end

  def advisory
  end

  def partners
  end

  def learn
  end

  def faqs
  end

  def research

  end

  def theme
  end

  def version
  end

  def sitemap
  end

  def governance_policy
  end

  def PEP_charter
  end

  def AC_charter
  end

  ## Educational content

  def obstructive_sleep_apnea
    @active_top_nav_link = :learn
    render 'static/SEO_content/obstructive_sleep_apnea'
  end

  def pap
    @active_top_nav_link = :learn
    render 'static/PAP'
  end

  def about_PAP_therapy
    @active_top_nav_link = :learn
    render 'static/SEO_content/about_PAP_therapy'
  end

  def PAP_setup_guide
    @active_top_nav_link = :learn
    render 'static/SEO_content/PAP_setup_guide'
  end

  def PAP_troubleshooting_guide
    @active_top_nav_link = :learn
    render 'static/SEO_content/PAP_troubleshooting_guide'
  end

  def PAP_care_maintenance
    @active_top_nav_link = :learn
    render 'static/SEO_content/PAP_care_maintenance'
  end

  def PAP_masks_equipment
    @active_top_nav_link = :learn
    render 'static/SEO_content/PAP_masks_equipment'
  end

  def traveling_with_PAP
    @active_top_nav_link = :learn
    render 'static/SEO_content/traveling_with_PAP'
  end

  def side_effects_PAP
    @active_top_nav_link = :learn
    render 'static/SEO_content/side_effects_PAP'
  end

  def sleep_tips
    @active_top_nav_link = :learn
    render 'static/sleep_tips/sleep_tips'
  end

  ## NON-STATIC
  ## TODO: Move out of here

  def home
    redirect_to root_path
  end

  def provider_page
    @provider = User.current.providers.find_by_slug(params[:slug])
    if @provider and @provider.slug.present?
      redirect_to provider_path(@provider.slug)
    else
      redirect_to providers_path
    end
  end

  private

  def load_pc
    @pc = page_content(params[:action].to_s)
  end

  def page_content(name)
    YAML.load_file(Rails.root.join('lib', 'data', 'content', "#{name}.yml"))[name]
  end

  def about_layout
  end

end
