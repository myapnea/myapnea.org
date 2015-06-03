class HomeController < ApplicationController

  before_action :authenticate_user!, except: [:dashboard, :landing]

  def dashboard
    if current_user
      flash.delete(:notice) if I18n.t('devise.sessions.signed_in') == flash[:notice]
      flash.delete(:alert)

      @active_top_nav_link = :home

      @surveys = current_user.visible_surveys.first(3)
      @posts = posts
    else
      render 'landing', layout: 'layouts/application-no-sidebar'
    end

  end

  def landing
    render layout: 'layouts/application-no-sidebar'
  end

  def posts
    @posts = Post.not_research.visible_for_user.includes(:user, topic: :forum).order(created_at: :desc).page(params[:page]).per(10)
  end

end
