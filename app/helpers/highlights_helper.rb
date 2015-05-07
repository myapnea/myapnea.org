module HighlightsHelper

  def safe_url?(url)
    ['http', 'https', 'ftp', 'mailto'].include?(URI.parse(url).scheme) rescue false
  end

end
