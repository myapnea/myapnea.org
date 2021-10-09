# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome
    user = User.first
    UserMailer.welcome(user)
  end

  def reply_on_subscribed_topic
    user = User.first
    reply = Reply.first
    UserMailer.reply_on_subscribed_topic(reply, user)
  end
end


