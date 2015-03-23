class StaticController < ApplicationController
  before_action :load_pc, only: [ :about, :team, :advisory, :learn, :faqs, :research ]
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

  ## Educational content

  def obstructive_sleep_apnea
    render 'static/SEO_content/obstructive_sleep_apnea'
  end

  def pap
    render 'static/PAP'
  end

  def about_PAP_therapy
    render 'static/SEO_content/about_PAP_therapy'
  end

  def PAP_setup_guide
    render 'static/SEO_content/PAP_setup_guide'
  end

  def PAP_troubleshooting_guide
    render 'static/SEO_content/PAP_troubleshooting_guide'
  end

  def PAP_care_maintenance
    render 'static/SEO_content/PAP_care_maintenance'
  end

  def PAP_masks_equipment
    render 'static/SEO_content/PAP_masks_equipment'
  end

  def traveling_with_PAP
    render 'static/SEO_content/traveling_with_PAP'
  end

  def side_effects_PAP
    render 'static/SEO_content/side_effects_PAP'
  end

  def sleep_tips
    render 'static/sleep_tips/sleep_tips'
  end


  ## NON-STATIC

  ## TODO: Move out of here
  def home
    flash.delete(:notice)
    flash.delete(:alert)
    if current_user
      @active_top_nav_link = :home
      @posts = Notification.blog_posts.viewable
      @surveys = current_user.visible_surveys.first(3)
    else
      render 'landing'
    end
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
    YAML.load_file(Rails.root.join('lib', 'data', 'myapnea', 'content', "#{name}.#{I18n.locale}.yml"))[I18n.locale.to_s][name]
  end

  def about_layout
  end

end
