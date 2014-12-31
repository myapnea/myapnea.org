class SocialProfile < ActiveRecord::Base
  mount_uploader :photo, PhotoUploader
  belongs_to :user

  validates_uniqueness_of :name, allow_blank: true, case_sensitive: false
  validates :age, numericality: {only_integer: true, less_than_or_equal_to: 120, allow_nil: true, greater_than_or_equal_to: 1}
  validates :sex, inclusion: { in: %w(Male Female Other), allow_nil: true}

  def self.locations_for_map(user=nil)
    res = select(:latitude, :longitude).where(show_location: true)
    res = res.where.not(id: user.social_profile.id) if user and user.social_profile

    res.map{|geo| {latitude: geo.latitude, longitude: geo.longitude} }
  end

  def self.states_for_map
    states = [ "us-ma", "us-wa", "us-ca", "us-or", "us-wi", "us-me", "us-mi", "us-nv", "us-nm", "us-co", "us-wy", "us-ks", "us-ne", "us-ok", "us-mo", "us-il", "us-in", "us-vt", "us-az", "us-ar", "us-tx", "us-ri", "us-al", "us-ga", "us-ms", "us-sc", "us-nc", "us-va", "us-ia", "us-md", "us-de", "us-nj", "us-pa", "us-ny", "us-id", "us-sd", "us-ct", "us-nh", "us-ky", "us-oh", "us-tn", "us-wv", "us-dc", "us-la", "us-fl", "us-mn", "us-mt", "us-nd", "us-ut", "us-hi", "us-ak" ]
    states.collect{|s| { "hc-key" => s, value: rand(50) }} + [ value: 51 ]
  end

  def show_publicly?
    make_public?
  end

  def photo_url
    if show_publicly? and photo.present?
      photo.url
    else
      'default-user.jpg'
    end
  end

  def public_location
    if show_publicly?
      location
    else
      "Anonymous Location"
    end
  end

  def public_nickname
    if show_publicly? and name.present?
      name
    else
      "Anonymous User #{Digest::MD5.hexdigest(user.email.to_s)[0,5]}"
    end
  end

  def location_for_map
    if latitude and longitude
      { latitude: latitude, longitude: longitude, title: name }
    else
      nil
    end
  end
end
