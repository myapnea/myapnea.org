# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  def forum_digest
    user = User.first
    UserMailer.forum_digest(user)
  end

  def post_replied
    post = Post.first
    user = User.first
    UserMailer.post_replied(post, user)
  end

  def welcome
    user = User.first
    UserMailer.welcome(user)
  end

  def mentioned_in_post
    user = User.first
    post = Post.first
    UserMailer.mentioned_in_post(post, user)
  end

end
