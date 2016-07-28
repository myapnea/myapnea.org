# frozen_string_literal: true

class ProvidersController < ApplicationController
  before_action :set_provider,              only: [:show] # , :edit, :update, :destroy
  before_action :redirect_without_provider, only: [:show] # , :edit, :update, :destroy
  before_action :set_SEO_elements

  def index
    provider_scope = User.providers_with_profiles
    provider_scope = provider_scope.where("users.provider_name ~* ?", params[:s].to_s.split(/\s/).collect{|l| l.to_s.gsub(/[^\w\d%]/, '')}.collect{|l| "(\\m#{l})"}.join("|")) if params[:s].present?
    @providers = provider_scope.page(params[:page]).per( 30 ).order("LOWER(provider_name)")
  end

  def new
    @provider = User.new
  end

  def show
  end

  def more
    provider_scope = User.providers_with_profiles
    provider_scope = provider_scope.where("users.provider_name ~* ?", params[:s].to_s.split(/\s/).collect{|l| l.to_s.gsub(/[^\w\d%]/, '')}.collect{|l| "(\\m#{l})"}.join("|")) if params[:s].present?
    @providers = provider_scope.page(params[:page]).per( 30 ).order("LOWER(provider_name)")
  end

  protected

  def set_provider
    @provider = User.current.providers.find_by_slug(params[:id])
  end

  def redirect_without_provider
    empty_response_or_root_path(providers_path) unless @provider
  end

  def set_SEO_elements
    @title = @provider.present? ? ('Sleep Provider - ' + @provider.provider_name) : 'Sleep Apnea Care Providers Registered with MyApnea'
    @page_content = 'Sleep apnea care providers can play a large role in improving quality of life for their patients with sleep apnea symptoms and diagnosed sleep apnea.'
  end
end
