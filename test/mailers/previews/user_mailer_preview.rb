# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  def forum_digest
    user = User.first
    UserMailer.forum_digest(user)
  end

end
