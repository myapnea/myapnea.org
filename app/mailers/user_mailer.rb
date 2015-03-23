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
    mail(to: @email_to, subject: "Forum Post Approved: #{@post.topic.name}")
  end

  def post_replied(post, user)
    setup_email
    @post = post
    @user = user
    @email_to = user.email
    mail(to: @email_to, subject: "New Forum Reply: #{@post.topic.name}")
  end

  def welcome(user)
    setup_email
    @user = user
    @email_to = user.email
    mail(to: @email_to, subject: "Welcome to MyApnea.Org!")
  end

  def mentioned_in_post(post, user)
    setup_email
    @user = user
    @post = post
    @email_to = user.email
    mail(to: @email_to,
      subject: "#{post.user.forum_name} Mentioned You on the MyApnea Forums")
  end

end
