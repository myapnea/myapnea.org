class StaticController < ApplicationController
  before_action :load_pc, only: [:about, :intro, :learn, :share, :research, :team, :faqs]
  before_action :about_layout, only: [:about, :intro, :learn, :share, :research, :team, :faqs]

  def content
    @page = params[:page]
    render "/static/content/#{@page}", :layout => "content"
  end

  def home
    if current_user
      @active_top_nav_link = :home
      @posts = Post.blog_posts.viewable
      render layout: "main"
    else
      render 'landing', layout: 'layouts/cleantheme'
    end
  end

  def theme
    render layout: "layouts/theme"
  end

  def landing
    if current_user
      redirect_to root_path
    else
      render layout: 'layouts/cleantheme'
    end
  end

  def stealth_steering
    render layout: 'layouts/cleantheme'
  end

  def stealth_forums
    render layout: 'layouts/cleantheme'
  end

  def stealth_datadisplay
    render layout: 'layouts/cleantheme'
  end

  def stealth_surveydisplay
    render layout: 'layouts/cleantheme'
  end

  private

  def load_pc
    @pc = page_content(params[:action].to_s)
  end

  def page_content(name)
    YAML.load_file(Rails.root.join('lib', 'data', 'myapnea', 'content', "#{name}.#{I18n.locale}.yml"))[I18n.locale.to_s][name]
  end

  def about_layout
    render layout: "layouts/about"
  end

end
