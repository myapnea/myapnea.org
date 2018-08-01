# frozen_string_literal: true

# Override for devise registrations controller.
class RegistrationsController < Devise::RegistrationsController
  append_after_action :check_consented_to_study, only: [:create]

  layout "layouts/full_page"

  private

  def check_consented_to_study
    # Load from session.
    project = Project.published.find_by(id: session[:project_id])
    full_name = session[:full_name]
    consented_at = session[:consented_at]
    # Clear session.
    session[:project_id] = nil
    session[:full_name] = nil
    session[:consented_at] = nil
    return unless resource && project.present? && full_name.present? && consented_at.present?
    resource.update(full_name: full_name)
    resource.consent!(project, consented_at: consented_at)
  end
end
