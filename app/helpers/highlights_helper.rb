# frozen_string_literal: true

module HighlightsHelper

  def safe_url?(url)
    ['http', 'https', 'ftp', 'mailto'].include?(URI.parse(url).scheme) rescue false
  end

  def highlight_photo_url(highlight)
    if highlight.photo.present?
      photo_highlight_path(highlight)
    else
      nil
    end
  end

end
