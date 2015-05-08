class SocialProfile < ActiveRecord::Base
  include Deletable

  mount_uploader :photo, PhotoUploader
  belongs_to :user

  validates_uniqueness_of :name, allow_blank: true, case_sensitive: false
  validates :age, numericality: {only_integer: true, less_than_or_equal_to: 120, allow_nil: true, greater_than_or_equal_to: 1}
  # validates :gender, inclusion: { in: %w(Male Female Other), allow_nil: true}

  def self.locations_for_map(user=nil)
    res = current.select(:latitude, :longitude).where(show_location: true)
    res = res.where.not(id: user.social_profile.id) if user and user.social_profile

    res.map{|geo| {latitude: geo.latitude, longitude: geo.longitude} }
  end

  # DEPRECATED 5.1
  def show_publicly?
    make_public?
  end
  # /deprecated

  def photo_url
    if photo.present?
      photo.url
    else
      'default-user.jpg'
    end
  end

  def public_location
    if location.present?
      location
    else
      "Anonymous Location"
    end
  end

  def public_nickname
    if name.present?
      name
    else
      SocialProfile.get_anonymous_name(user.email)
    end
  end

  def location_for_map
    if latitude and longitude
      { latitude: latitude, longitude: longitude, title: name }
    else
      nil
    end
  end

  def self.get_anonymous_name(input)
    "Member#{Digest::MD5.hexdigest(input.to_s).hex.to_s[0..5]}"
  end

  def self.generate_forum_name(input, additional_seed = nil)
    input    += additional_seed if additional_seed
    seed      = Digest::MD5.hexdigest(input.to_s).hex.to_s
    adjective = adjectives[(seed[0..3].to_i  % adjectives.size)]
    color     =     colors[(seed[4..7].to_i  % colors.size)]
    animal    =    animals[(seed[8..11].to_i % animals.size)]
    "#{adjective}#{color}#{animal}#{seed[12..15]}"
  end

  def self.adjectives
    @adjectives ||= load_yaml('adjectives')
  end

  def self.colors
    @colors ||= load_yaml('colors')
  end

  def self.animals
    @animals ||= load_yaml('animals')
  end

  private

  def self.load_yaml(name)
    YAML.load_file(Rails.root.join('lib', 'data', 'profiles', "#{name}.yml"))
  end

end
