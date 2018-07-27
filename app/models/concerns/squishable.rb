# frozen_string_literal: true

# Removes white space from model attributes
module Squishable
  extend ActiveSupport::Concern

  # Squishes together white space inside and outside of string.
  #   include Squishable
  #   squish :name, :description
  module ClassMethods
    def squish(*attributes)
      attributes.each do |attribute|
        class_eval <<-RUBY, __FILE__, __LINE__ + 1
          def #{attribute}=(attribute)
            super(attribute.try(:squish))
          end
        RUBY
      end
    end
  end
end
