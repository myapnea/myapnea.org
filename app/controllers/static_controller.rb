# frozen_string_literal: true

class StaticController < ApplicationController
  before_action :set_active_top_nav_link_to_learn, only: [:learn]
  skip_before_action :check_ip_banlist, only: [:about]

  ## Static
  def about
    @page_content = "Can't sleep? Sleep apnea is one of the largest causes of chronic sleep deprivation. MyApnea.Org was created by people with sleep apnea, sleep researchers, and sleep doctors to help people with sleep apnea treat their sleep apnea symptoms."
  end

  def team
    @team_members = Admin::TeamMember.current.order('position')
  end

  def pep_corner
    @pep_members = Admin::TeamMember.current.where(group: 'patient').where.not(interview: nil).order('position')
  end

  def pep_corner_show
    @pep_member = Admin::TeamMember.find(params[:pep_id])
  end

  def partners
    @partners = Admin::Partner.current.where(displayed: true).order(:position)
  end

  def learn
    @page_content = "If you can't sleep, are experiencing sleep apnea symptoms, have been diagnosed with obstructive sleep apnea or central sleep apnea, MyApnea wants to help you understand sleep apnea and sleep apnea causes."
  end

  def faqs
    @page_content = "What is MyApnea? What is the difference between OSA and CSA? Where can you take sleep tests? If you are experiencing sleep deprivation or sleep apnea symptoms, MyApnea will explain the basics."
  end

  def clinical_trials
    @clinical_trials = Admin::ClinicalTrial.current.order(:position)
  end

  def version
  end

  def sitemap
  end

  def governance_policy
  end

  def pep_charter
  end

  # PAP Devices

  def pap
    render 'static/pap'
  end

  def about_pap_therapy
    render 'learn/about_pap_therapy'
  end

  def pap_setup_guide
    render 'learn/pap_setup_guide'
  end

  def pap_troubleshooting_guide
    render 'learn/pap_troubleshooting_guide'
  end

  def pap_care_maintenance
    render 'learn/pap_care_maintenance'
  end

  def pap_masks_equipment
    render 'learn/pap_masks_equipment'
  end

  def traveling_with_pap
    render 'learn/traveling_with_pap'
  end

  def side_effects_pap
    render 'learn/side_effects_pap'
  end

  ## NON-STATIC
  ## TODO: Move out of here

  def provider_page
    @provider = User.current.providers.find_by_slug(params[:slug])
    if @provider && @provider.slug.present?
      redirect_to provider_path(@provider.slug)
    else
      redirect_to providers_path
    end
  end
end
