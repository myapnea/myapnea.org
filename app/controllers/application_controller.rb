# frozen_string_literal: true

# Main controller for MyApnea. Tracks the user's last visited page for better
# page redirection after sign in and sign out.
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token, if: :devise_login?
  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :store_location

  def store_location
    return unless !request.post? && !request.xhr? && params[:format] != "atom" && params[:format] != "pdf"
    store_internal_location_in_session if internal_action?(params[:controller], params[:action])
    store_external_location_in_session if external_action?(params[:controller], params[:action])
    clear_location_in_session if params[:controller] == "external" && params[:action] == "landing"
  end

  def after_sign_in_path_for(resource)
    join_study_path || session[:previous_internal_url] || session[:previous_external_url] || dashboard_path
  end

  def after_sign_out_path_for(resource_or_scope)
    session[:previous_external_url] || root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [
        :username, :email, :password, :emails_enabled,
        :textcaptcha_answer, :textcaptcha_key
      ]
    )
  end

  protected

  def join_study_path
    # Load from session.
    project = Project.published.find_by(id: session[:project_id])
    full_name = session[:full_name]
    consented_at = session[:consented_at]
    # Clear session.
    session[:project_id] = nil
    session[:full_name] = nil
    session[:consented_at] = nil
    return unless current_user && project.present? && full_name.present? && consented_at.present?
    current_user.update(full_name: full_name)
    current_user.consent!(project, consented_at: consented_at)
    flash[:notice] = "Thank you for agreeing to participate in the #{project.name} research study!"
    slice_overview_path(project)
  end

  def internal_controllers
    {
      account: [],
      admin: [],
      broadcasts: [],
      images: [:index, :show, :new, :edit],
      internal: [],
      notifications: [],
      participate: [],
      topics: [:new, :edit],
      users: []
    }
  end

  def internal_action?(controller, action)
    internal_controllers[controller.to_sym] && (
      internal_controllers[controller.to_sym].empty? ||
      internal_controllers[controller.to_sym].include?(action.to_sym)
    )
  end

  def external_controllers
    {
      blog: [:blog, :show],
      external: [
        :community, :consent, :contact, :faqs, :partners,
        :privacy_policy, :terms_and_conditions, :terms_of_access, :team,
        :voting
      ],
      members: [:index, :show],
      replies: [:show],
      search: [],
      slice: [],
      tools: [],
      topics: [:index, :show]
    }
  end

  def external_action?(controller, action)
    external_controllers[controller.to_sym] && (
      external_controllers[controller.to_sym].empty? ||
      external_controllers[controller.to_sym].include?(action.to_sym)
    )
  end

  def store_internal_location_in_session
    session[:previous_internal_url] = request.fullpath
  end

  def store_external_location_in_session
    session[:previous_external_url] = request.fullpath
    session[:previous_internal_url] = nil
  end

  def clear_location_in_session
    session[:previous_external_url] = nil
    session[:previous_internal_url] = nil
  end

  def devise_login?
    params[:controller] == "sessions" && params[:action] == "create"
  end

  def empty_response_or_root_path(path = root_path)
    respond_to do |format|
      format.html { redirect_to path }
      format.js { head :ok }
      format.json { head :no_content }
      format.pdf { redirect_to path }
      format.text { head :no_content }
    end
  end

  def check_admin
    return if current_user&.admin?
    redirect_to root_path
  end

  def parse_date(date_string, default_date = nil)
    if date_string.to_s.split("/").last.size == 2
      Date.strptime(date_string, "%m/%d/%y")
    else
      Date.strptime(date_string, "%m/%d/%Y")
    end
  rescue
    default_date
  end

  def parse_date_if_key_present(object, key)
    return unless params[object].key?(key)
    params[object][key] = parse_date(params[object][key]) if params[object].key?(key)
  end

  def scrub_order(model, params_order, default_order)
    (params_column, params_direction) = params_order.to_s.strip.downcase.split(" ")
    direction = (params_direction == "desc" ? "desc nulls last" : nil)
    column_name = (model.column_names.collect{|c| model.table_name + "." + c}.select{|c| c == params_column}.first)
    order = column_name.blank? ? default_order : [column_name, direction].compact.join(" ")
    order
  end

  # Expects an "Uploader" type class, ex: uploader = @project.logo
  def send_file_if_present(uploader, *args)
    if uploader.present?
      send_file uploader.path, *args
    else
      head :ok
    end
  end
end
