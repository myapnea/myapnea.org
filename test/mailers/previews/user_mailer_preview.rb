# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome
    user = User.first
    UserMailer.welcome(user)
  end

  def followup_survey
    answer_session = AnswerSession.last
    UserMailer.followup_survey(answer_session)
  end

  def new_surveys_available
    user = User.second
    UserMailer.new_surveys_available(user)
  end

  def encounter_digest
    owner = User.first
    UserMailer.encounter_digest(owner, 84, { "about-me" => { name: "About Me", encounters: [ { name: "Follow Up", answer_sessions_change: 50 } ] }, "more-about-me" => { name: "More About Me", encounters: [ { name: "Seasonal Follow Up", answer_sessions_change: 12 }, { name: "Second Month", answer_sessions_change: 22 } ] } })
  end

  def export_ready
    export = Admin::Export.first
    UserMailer.export_ready(export)
  end
end
