# frozen_string_literal: true

# Provides methods to count the number of URL in text
module UrlCountable
  extend ActiveSupport::Concern

  def count_urls(text)
    URI.extract(text, /http(s)?|mailto|ftp/).count
  end
end
