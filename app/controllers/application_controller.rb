# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include DateAndTimeParser

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout :set_layout

  before_action :store_location
  before_action :check_ip_banlist

  def store_location
    if (params[:controller].in?(%w(topics blog replies)) &&
        !request.fullpath.match("#{request.script_name}/login") &&
        !request.fullpath.match("#{request.script_name}/join") &&
        !request.fullpath.match("#{request.script_name}/password") &&
        !request.fullpath.match("#{request.script_name}/sign_out") &&
        params[:format] != 'atom' &&
        !request.xhr?) || # don't store ajax calls
        request.fullpath.match("#{request.script_name}/join-health-eheart") ||
        request.fullpath.match("#{request.script_name}/welcome-health-eheart-members")
      store_location_in_session
    end
  end

  def set_active_top_nav_link_to_surveys
    @active_top_nav_link = :surveys
  end

  def set_active_top_nav_link_to_learn
    @active_top_nav_link = :learn
  end

  def authenticate_research
    session[:return_to] = request.fullpath
    if current_user.ready_for_research?
      return
    else
      if current_user.provider? or current_user.is_only_academic?
        redirect_to terms_of_access_path
      else
        redirect_to consent_path
      end
    end
  end

  def empty_response_or_root_path(path = root_path)
    respond_to do |format|
      format.html { redirect_to path }
      format.js { head :ok }
      format.json { head :no_content }
      format.text { head :no_content }
    end
  end

  def check_owner_or_moderator
    redirect_to root_path, alert: "You do not have sufficient privileges to access that page." unless current_user and (current_user.owner? or current_user.moderator?)
  end

  def check_owner
    redirect_to root_path, alert: "You do not have sufficient privileges to access that page." unless current_user and current_user.owner?
  end

  def after_sign_in_path_for(resource)
    session[:previous_url] || root_path
  end

  def check_ip_banlist
    return if BANNED_IPS.empty?
    redirect_to about_path, notice: 'Thank you for your contribution!' if ip_banned?
  end

  def ip_banned?
    !BANNED_IPS.find { |ip| ip_matches?(ip, request.remote_ip) }.nil?
  end

  def ip_matches?(one, two)
    aone = one.split('.')
    atwo = two.split('.')
    (aone[0] == '*' || aone[0] == atwo[0]) && (aone[1] == '*' || aone[1] == atwo[1]) && (aone[2] == '*' || aone[2] == atwo[2]) && (aone[3] == '*' || aone[3] == atwo[3])
  end

  protected

  def set_layout
    devise_controller? ? 'simple' : nil
  end

  def store_location_in_session
    session[:previous_url] = request.fullpath
  end

  def scrub_order(model, params_order, default_order)
    (params_column, params_direction) = params_order.to_s.strip.downcase.split(' ')
    direction = (params_direction == 'desc' ? 'desc nulls last' : nil)
    column_name = (model.column_names.collect{|c| model.table_name + "." + c}.select{|c| c == params_column}.first)
    order = column_name.blank? ? default_order : [column_name, direction].compact.join(' ')
    order
  end

  def verify_recaptcha
    url = URI.parse('https://www.google.com/recaptcha/api/siteverify')
    http = Net::HTTP.new(url.host, url.port)
    if url.scheme == 'https'
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
    post_params = [
      "secret=#{ENV['recaptcha_secret_key']}",
      "response=#{params['g-recaptcha-response']}",
      "remoteip=#{request.remote_ip}"
    ]
    response = http.start do |h|
      h.post(url.path, post_params.join('&'))
    end
    json = JSON.parse(response.body)
    json['success']
  end
end
