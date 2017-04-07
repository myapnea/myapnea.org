# frozen_string_literal: true

# Sends out application emails to users
class UserMailer < ApplicationMailer
  def welcome(user)
    setup_email
    @user = user
    @email_to = user.email
    mail(to: @email_to, subject: 'Welcome to MyApnea.Org!')
  end

  def followup_survey(answer_session)
    setup_email
    @answer_session = answer_session
    @user = answer_session.user
    @email_to = answer_session.user.email
    mail(to: @email_to, subject: 'Followup Survey Available on MyApnea.Org!')
  end

  def new_surveys_available(user)
    setup_email
    @user = user
    @email_to = user.email
    mail(to: @email_to, subject: 'New Surveys Available on MyApnea.Org!')
  end

  def encounter_digest(admin, surveys_launched, survey_changes)
    setup_email
    @admin = admin
    @surveys_launched = surveys_launched
    @survey_changes = survey_changes
    @email_to = admin.email
    mail(to: @email_to,
         subject: "#{surveys_launched} Followup Survey#{'s' if surveys_launched != 1} \
Launched on #{Time.zone.today.strftime('%a %d %b %Y')}")
  end

  def export_ready(export)
    @export = export
    @email_to = export.user.email
    mail(to: "#{export.user.name} <#{export.user.email}>",
         subject: "Your Data Export #{export.name} is now Ready")
  end
end
