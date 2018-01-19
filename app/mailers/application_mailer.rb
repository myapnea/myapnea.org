# frozen_string_literal: true

# Generic mailer class defines layout and from email address
class ApplicationMailer < ActionMailer::Base
  default from: "#{ENV["website_name"]} <#{ActionMailer::Base.smtp_settings[:email]}>"
  add_template_helper(EmailHelper)
  add_template_helper(MarkdownHelper)
  layout "mailer"

  protected

  def setup_email
    location = "app/assets/images/myapnea/logos/MyApneaLogo_border_whitetext_300x80.png"
    attachments.inline["myapnea-logo.png"] = File.read(location)
  rescue
    nil
  end
end
