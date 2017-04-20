# frozen_string_literal: true

# Sends out application emails to users
class UserMailer < ApplicationMailer
  def welcome(user)
    setup_email
    @user = user
    @email_to = user.email
    mail(to: @email_to, subject: 'Welcome to MyApnea.Org!')
  end
end
