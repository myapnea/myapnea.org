class StaticController < ApplicationController
  before_action :load_pc, only: [ :about, :share, :team, :advisory, :learn, :faqs, :research ]
  before_action :about_layout, only: [ :research ]

  def home
    flash.delete(:notice)
    if current_user
      @active_top_nav_link = :home
      @posts = Notification.blog_posts.viewable
      render layout: "main"
    else
      render 'landing', layout: 'layouts/cleantheme'
    end
  end

  def about
    render layout: 'layouts/cleantheme'
  end

  # Alias for about
  def share
    render layout: 'layouts/cleantheme'
  end

  def team
    render layout: 'layouts/cleantheme'
  end

  def advisory
    render layout: 'layouts/cleantheme'
  end

  def partners
    render layout: 'layouts/cleantheme'
  end

  def learn
    render layout: 'layouts/cleantheme'
  end

  def faqs
    render layout: 'layouts/cleantheme'
  end

  def research

  end

  def theme
    render layout: 'layouts/cleantheme'
  end

  def version
    render layout: 'layouts/cleantheme'
  end

  def provider_page
    @provider = User.current.where(user_type: 'provider').find_by_slug(params[:slug])
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
    render layout: "layouts/about" unless params[:redesign] == '1'
  end

end
