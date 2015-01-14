class Provider < User
  validates_presence_of :provider_name, :slug
  validates_uniqueness_of :slug, :provider_name

  has_many :users, class_name: "User", foreign_key: "provider_id"

  private


end
