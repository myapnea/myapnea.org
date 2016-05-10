# frozen_string_literal: true

class Unit < ActiveRecord::Base
  include Localizable

  localize :name

end
