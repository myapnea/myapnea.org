class Provider < User
  validates_presence_of :provider_name, :slug


  private


end
