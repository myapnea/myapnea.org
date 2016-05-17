# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!, except: [:dashboard, :landing]
  before_action :set_active_top_nav_link_to_home

  before_action :set_SEO_elements

  def dashboard
    if current_user
      flash.delete(:notice) if I18n.t('devise.sessions.signed_in') == flash[:notice]
      flash.delete(:alert)

      if session[:incoming_heh_token].present?
        redirect_to link_health_eheart_member_path
        return
      end

      @surveys = Survey.current.viewable.non_pediatric.limit(3)
      @answer_sessions = current_user.answer_sessions.joins(:survey).where(child_id: nil).where.not(surveys: { slug: nil }).order(:locked, "surveys.name_en", :encounter).limit(3)
      @posts = posts

      current_user.is_only_academic? ? load_academic_dashboard_resources : load_member_dashboard_resources
    else
      render 'home/landing', layout: 'home'
    end
  end

  def landing
    render 'home/landing', layout: 'home'
  end

  def posts
    if current_user.is_only_academic?
      @posts = academic_posts.page(params[:page]).per(10)
    else
      @posts = member_posts.page(params[:page]).per(10)
    end
  end

  private

  def load_academic_dashboard_resources
    @surveys = Survey.current.viewable.non_pediatric.limit(3)
    @posts = posts
  end

  def load_member_dashboard_resources
    @surveys = Survey.current.viewable.non_pediatric.limit(3)
    @answer_sessions = current_user.answer_sessions.joins(:survey).where(child_id: nil).where.not(surveys: { slug: nil }).order(:locked, "surveys.name_en", :encounter).limit(3)
    @posts = posts
  end

  def member_posts
    Post.current.not_research.visible_for_user.includes(:user, topic: :forum).order(created_at: :desc).page(params[:page]).per(10)
  end

  def academic_posts
    Post.joins(:reactions).where("reactions.id IS NOT NULL AND reactions.form = 'request_expert_comment' AND reactions.deleted = 'f'").group(Post.columns_for_group).reverse_order
  end

  def set_SEO_elements
    @page_title = 'Sleep Apnea Research and Community for Patient Outcomes'
    @page_content = 'Answer research surveys, submit and vote on new research questions, see the latest forum activity, and get involved in the sleep apnea community here at MyApnea.Org'
  end
end
