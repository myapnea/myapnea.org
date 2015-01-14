class Provider < User
  mount_uploader :photo, PhotoUploader
  validates_presence_of :provider_name, :slug
  validates_uniqueness_of :slug, :provider_name

  has_many :users, class_name: "User", foreign_key: "provider_id"

  def photo_url
    if photo.present?
      photo.url
    else
      'default-user.jpg'
    end
  end

  def get_welcome_message
    if welcome_message.present?
      welcome_message
    else
      "Welcome to my provider page!"
    end
  end

  private

end
