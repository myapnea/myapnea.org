class ProvidersController < ApplicationController
  before_action :set_provider,              only: [ :show ] # , :edit, :update, :destroy
  before_action :redirect_without_provider, only: [ :show ] # , :edit, :update, :destroy

  def index
    provider_scope = User.where(provider: true).where.not(slug: [nil,''], provider_name: [nil,''])
    provider_scope = provider_scope.where("users.provider_name ~* ?", params[:s].to_s.split(/\s/).collect{|l| l.to_s.gsub(/[^\w\d%]/, '')}.collect{|l| "(\\m#{l})"}.join("|")) if params[:s].present?
    @providers = provider_scope.page(params[:page]).per( 12 ).order(:provider_name)
  end

  def new
    @provider = User.new
    render layout: 'layouts/application-no-sidebar'
  end

  def show
    render layout: 'layouts/application-no-sidebar'
  end

  protected

    def set_provider
      @provider = User.current.providers.find_by_slug(params[:id])
    end

    def redirect_without_provider
      empty_response_or_root_path(providers_path) unless @provider
    end

end
