# frozen_string_literal: true

class HomeController < ApplicationController
  def dashboard
    if current_user
      flash.delete(:notice) if I18n.t('devise.sessions.signed_in') == flash[:notice]
      flash.delete(:alert)

      if session[:incoming_heh_token].present?
        redirect_to link_health_eheart_member_path
        return
      end

      @surveys = Survey.current.viewable.non_pediatric.limit(3)
      @answer_sessions = current_user.answer_sessions.joins(:survey).no_child.where.not(surveys: { slug: nil }).order(:locked, "surveys.name_en", :encounter).limit(3)

      current_user.is_only_researcher? ? load_academic_dashboard_resources : load_member_dashboard_resources
    else
      render 'home/landing'
    end
  end

  def landing
  end

  private

  def load_academic_dashboard_resources
    @surveys = Survey.current.viewable.non_pediatric.limit(3)
  end

  def load_member_dashboard_resources
    @surveys = Survey.current.viewable.non_pediatric.limit(3)
    @answer_sessions = current_user.answer_sessions.joins(:survey).no_child.where.not(surveys: { slug: nil }).order(:locked, "surveys.name_en", :encounter).limit(3)
  end
end
