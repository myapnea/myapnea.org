# frozen_string_literal: true

module ApplicationHelper
  include DateAndTimeParser

  def simple_check(checked)
    content_tag(:i, "", class: "fa #{checked ? "fa-check-square-o" : "fa-square-o"}")
  end

  def simple_bold(text)
    text.to_s.gsub(/\*\*(.*?)\*\*/, "<strong>\\1</strong>").html_safe
  end

  # TODO: Remove references to page_content
  def page_content(name)
    YAML.load_file(Rails.root.join('lib', 'data', 'content', "#{name}.yml"))[name]
  end
end
