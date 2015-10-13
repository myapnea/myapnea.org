module UsersHelper

  def user_photo_url(user)
    if user.photo.present?
      photo_user_path(user)
    else
      'default-user.jpg'
    end
  end

end
