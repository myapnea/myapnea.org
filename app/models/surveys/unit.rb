class Unit < ActiveRecord::Base
  include Localizable

  localize :name

end