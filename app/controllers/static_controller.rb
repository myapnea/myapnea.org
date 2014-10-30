class StaticController < ApplicationController
  before_action :load_pc, only: [:about, :intro, :learn, :share, :research, :team, :faqs ]
  before_action :about_layout, only: [:about, :intro, :learn, :share, :research, :team, :faqs]

  def content
    @page = params[:page]
    render "/static/content/#{@page}", :layout => "content"
  end

  def home
    @active_top_nav_link = :home
    @posts = Post.blog_posts.viewable
    render layout: "main"
  end

  def theme
    render layout: "layouts/theme"
  end

  private

  def load_pc
    @pc = page_content(params[:action].to_s)
  end

  def page_content(name)
    YAML.load_file(Rails.root.join('lib', 'data', 'content', "#{name}.#{I18n.locale}.yml"))[I18n.locale.to_s][name]
  end

  def about_layout
    render layout: "layouts/about"
  end

end
