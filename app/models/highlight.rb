class Highlight < ActiveRecord::Base

  include Deletable

  mount_uploader :photo, PhotoUploader

end
