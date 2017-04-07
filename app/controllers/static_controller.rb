# frozen_string_literal: true

# Displays static pages for public users.
class StaticController < ApplicationController
  skip_before_action :check_ip_banlist, only: [:about]

  def about
    # render layout: 'simple'
    render layout: 'blank2'
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
    @page_content = "If you can't sleep, are experiencing sleep apnea symptoms"\
                    ', have been diagnosed with obstructive sleep apnea or cen'\
                    'tral sleep apnea, MyApnea wants to help you understand sl'\
                    'eep apnea and sleep apnea causes.'
  end

  def faqs
    render layout: 'simple'
  end

  def clinical_trials
    @clinical_trials = Admin::ClinicalTrial.current.order(:position)
  end

  # def version
  # end

  # def sitemap
  # end

  # def governance_policy
  # end

  # def pep_charter
  # end

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
end
