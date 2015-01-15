class ApplicationMailer < ActionMailer::Base
  default from: "#{ENV['pprn_title']} <#{ActionMailer::Base.smtp_settings[:email]}>"
  add_template_helper(ForumsHelper)
  layout 'mailer'
end
