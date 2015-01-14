class UserMailer < ApplicationMailer

  def forum_digest(user)
    setup_email
    @user = user
    @email_to = user.email
    mail(to: user.email, subject: "Forum Digest for #{Date.today.strftime('%a %d %b %Y')}")
  end

  protected

  def setup_email
    attachments.inline['myapnea-logo.png'] = File.read('app/assets/images/myapnea/MyApneaLogo_border_whitesub_300x80.png') rescue nil
  end

end
