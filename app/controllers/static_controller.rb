class StaticController < ApplicationController
  before_action :set_active_top_nav_link_to_learn, only: [:learn]

  before_action :load_pc, only: [ :team, :advisory, :learn, :research ]
  before_action :about_layout, only: [ :research ]

  before_action :set_SEO_elements

  ## Static
  def about
    @page_content = "Can't sleep? Sleep apnea is one of the largest causes of chronic sleep deprivation. MyApnea.Org was created by people with sleep apnea, sleep researchers, and sleep doctors to help people with sleep apnea treat their sleep apnea symptoms."
  end

  def team
  end

  def advisory
    @page_content = "The MyApnea advisory council consists of sleep researchers, sleep apnea care providers, experts in CPAP and CPAP masks, and people with sleep apnea."
    @group1 = []; @group2 = []; @group3 = []
    @pc["members"].each_with_index do |member, index|
      if index % 3 == 0
        @group1.push(member)
      elsif index % 2 == 0
        @group3.push(member)
      else
        @group2.push(member)
      end
    end
  end

  def partners
    @page_content = "MyApnea is proud to partner with organizations devoted to improving health and improving sleep quality."
  end

  def learn
    @page_content = "If you can't sleep, are experiencing sleep apnea symptoms, have been diagnosed with obstructive sleep apnea or central sleep apnea, MyApnea wants to help you understand sleep apnea and sleep apnea causes."
    render layout: 'layouts/application-no-sidebar'
  end

  def faqs
    @page_content = "What is MyApnea? What is the difference between OSA and CSA? Where can you take sleep tests? If you are experiencing sleep deprivation or sleep apnea symptoms, MyApnea will explain the basics."
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

  def what_is_sleep_apnea
    render 'static/SEO_content/what_is_sleep_apnea'
  end

  def obstructive_sleep_apnea
    render 'static/SEO_content/obstructive_sleep_apnea'
  end

  def central_sleep_apnea
    render 'static/SEO_content/central_sleep_apnea'
  end

  def causes
    render 'static/SEO_content/causes'
  end

  def symptoms
    render 'static/SEO_content/symptoms'
  end

  def risk_factors
    render 'static/SEO_content/risk_factors'
  end

  def diagnostic_process
    render 'static/SEO_content/diagnostic_process'
  end

  def treatment_options
    render 'static/SEO_content/treatment_options'
  end

  # PAP Devices

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

  ## THEME

  def sizes
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

    def set_SEO_elements
      @page_title = ''
      @page_content = ''
    end

end
