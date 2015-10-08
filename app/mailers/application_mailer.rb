class ApplicationMailer < ActionMailer::Base
  default from: "#{ENV['pprn_title']} <#{ActionMailer::Base.smtp_settings[:email]}>"
  add_template_helper(ForumsHelper)
  layout 'mailer'

  protected

  def setup_email
    attachments.inline['myapnea-logo.png'] = File.read('app/assets/images/myapnea/logos/MyApneaLogo_border_whitetext_300x80.png')
  rescue
    nil
  end
end
