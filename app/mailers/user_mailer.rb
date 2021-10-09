# frozen_string_literal: true

# Sends out application emails to users
class UserMailer < ApplicationMailer
  def welcome(user)
    setup_email
    @user = user
    @email_to = user.email
    mail(to: @email_to, subject: "Welcome to MyApnea!")
  end

  def reply_on_subscribed_topic(reply, user)
    setup_email
    @reply = reply
    @user = user
    @email_to = user.email
    mail(to: @email_to, subject: "New reply on \"#{reply.topic.title}\" on the MyApnea forum")
   end
end
