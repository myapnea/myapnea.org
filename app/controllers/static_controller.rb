class StaticController < ApplicationController
  before_action :load_pc, only: [:learn, :share, :research, :team, :faqs, :privacy_policy ]

  def content
    @page = params[:page]
    render "/static/content/#{@page}", :layout => "content"
  end

  def home
    @active_top_nav_link = :home
    @posts = Post.blog_posts.viewable
    render layout: "community"
  end


  # def home
  #   @research_qs = Group.find_by_name("Research Questions").questions.sort_by{|q| -q.rating }
  # end

  def theme
    #raise StandardError
    #render layout: "layouts/theme"
  end

  private

  def load_pc
    @pc = page_content(params[:action].to_s)
  end

  def page_content(name)
    YAML.load_file(Rails.root.join('lib', 'data', 'content', "#{name}.#{I18n.locale}.yml"))[I18n.locale.to_s][name]
  end
  #
  # def temm
  #   path = File.expand_path('../myapnea', __FILE__)
  #   self.view_path.push(*path)
  # end


end
