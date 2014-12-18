module ForumsHelper

  def strip_quote(text)
    text.to_s.gsub(/<blockquote>(.*?)<\/blockquote>/m, '').strip
  end

end
