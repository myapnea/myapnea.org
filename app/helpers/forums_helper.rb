module ForumsHelper

  def strip_quote(text)
    simple_markdown(text).gsub(/<blockquote>(.*?)<\/blockquote>/m, '').strip
  end

  def simple_markdown(text, allow_links = true, target_blank = true, table_class = '')
    result = ''
    markdown = Redcarpet::Markdown.new( Redcarpet::Render::HTML, no_intra_emphasis: true, fenced_code_blocks: true, autolink: true, strikethrough: true, superscript: true, tables: true, lax_spacing: true, space_after_headers: true, underline: true, highlight: true, footnotes: true )
    result = markdown.render(text.to_s)
    result = add_table_class(result, table_class) unless table_class.blank?
    result = replace_p_with_p_lead(result)
    result = make_images_responsive(result)
    unless allow_links
      result = remove_links(result)
      result = remove_images(result)
      result = remove_tables(result)
    end
    result = target_link_as_blank(result) if target_blank
    result.html_safe
  end

  def style_forum_post(text)
    (text).html_safe
  end

  def target_link_as_blank(text)
    text.to_s.gsub(/<a(.*?)>/m, '<a\1 class="content-link" target="_blank">').html_safe
  end

  def remove_links(text)
    text.to_s.gsub(/<a[^>]*? href="(.*?)">(.*?)<\/a>/m, '\1')
  end

  def remove_images(text)
    text.to_s.gsub(/<img(.*?)>/m, '')
  end

  def remove_tables(text)
    text.to_s.gsub(/<table(.*?)>(.*?)<\/table>/m, '')
  end

  def replace_p_with_p_lead(text)
    text.to_s.gsub(/<p>/m, '<p class="lead" data-object="link-forum-names">').html_safe
  end

  def add_table_class(text, table_class)
    text.to_s.gsub(/<table>/m, "<table class=\"#{table_class}\">").html_safe
  end

  def make_images_responsive(text)
    text.to_s.gsub(/<img/, '<img class="img-responsive"').html_safe
  end

end
