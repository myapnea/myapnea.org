# frozen_string_literal: true

# TODO: Remove in v17.0.0
module Localizable
  extend ActiveSupport::Concern

  module ClassMethods
    def localize(attr)
      localized_attr = [attr, I18n.locale].join('_')

      unless column_names.include? localized_attr
        localized_attr = [attr, I18n.default_locale].join('_')
      end

      define_method attr do
        self[localized_attr]
      end
    end
  end
end
