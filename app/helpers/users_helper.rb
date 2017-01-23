# frozen_string_literal: true

module UsersHelper
  def user_photo_url(user)
    if user.photo.present?
      photo_user_path(user, t: user.updated_at.usec)
    else
      'default-user.jpg'
    end
  end
end
