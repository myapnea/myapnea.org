class UserMailer < ApplicationMailer

  def forum_digest(user)
    setup_email
    @user = user
    @email_to = user.email
    mail(to: @email_to, subject: "Forum Digest for #{Date.today.strftime('%a %d %b %Y')}")
  end

  def post_approved(post, moderator)
    setup_email
    @post = post
    @email_to = post.user.email
    @moderator = moderator
    mail(to: @email_to, subject: "Your Forum Post has been Approved")
  end

  def post_replied(post, user)
    setup_email
    @post = post
    @user = user
    @email_to = user.email
    mail(to: @email_to, subject: "Someone Posted a Reply to one of Your Subscribed Topics")
  end

  protected

  def setup_email
    attachments.inline['myapnea-logo.png'] = File.read('app/assets/images/myapnea/MyApneaLogo_border_whitesub_300x80.png') rescue nil
  end

end
