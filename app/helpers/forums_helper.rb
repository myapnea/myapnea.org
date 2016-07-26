# frozen_string_literal: true

# Renders text using markdown into formatted html
module ForumsHelper
  def strip_quote(text)
    simple_markdown(text).gsub(/<blockquote>(.*?)<\/blockquote>/m, '').strip
  end

  def simple_markdown_new(text, target_blank: true, table_class: '', allow_links: true, allow_lists: true)
    simple_markdown(text, allow_links, target_blank, table_class, allow_lists)
  end

  def simple_markdown(text, allow_links = true, target_blank = true, table_class = '', allow_lists = true)
    markdown = Redcarpet::Markdown.new(
      Redcarpet::Render::HTML,
      no_intra_emphasis: true, fenced_code_blocks: true, autolink: true,
      strikethrough: true, superscript: true, tables: true, lax_spacing: true,
      space_after_headers: true, underline: true, highlight: true, footnotes: true
    )
    result = text.to_s
    result = replace_numbers_with_ascii(result) unless allow_lists
    result = markdown.render(result)
    result = result.encode('UTF-16', undef: :replace, invalid: :replace, replace: '').encode('UTF-8')
    result = add_table_class(result, table_class) unless table_class.blank?
    result = add_link_forum_names_to_paragraph(result)
    unless allow_links
      result = remove_links(result)
      result = remove_images(result)
      result = remove_tables(result)
    end
    result = target_link_as_blank(result) if target_blank
    result.html_safe
  end

  def target_link_as_blank(text)
    text.to_s.gsub(/<a(.*?)>/m, '<a\1 class="content-link" target="_blank">').html_safe
  end

  def remove_links(text)
    text.to_s.gsub(%r{<a[^>]*? href="(.*?)">(.*?)</a>}m, '\1')
  end

  def remove_images(text)
    text.to_s.gsub(/<img(.*?)>/m, '')
  end

  def remove_tables(text)
    text.to_s.gsub(%r{<table(.*?)>(.*?)</table>}m, '')
  end

  def add_link_forum_names_to_paragraph(text)
    text.to_s.gsub(/<p>/m, '<p data-object="link-forum-names">').html_safe
  end

  def add_table_class(text, table_class)
    text.to_s.gsub(/<table>/m, "<table class=\"#{table_class}\">").html_safe
  end

  def replace_numbers_with_ascii(text)
    text.gsub(/^[ \t]*(\d)/) { |m| ascii_number($1) }
  end

  def ascii_number(number)
    "&##{(number.to_i + 48).to_s};"
  end
end
