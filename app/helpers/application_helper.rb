# frozen_string_literal: true

# Generic methods uses across the application views.
module ApplicationHelper
  include DateAndTimeParser

  def simple_check(checked)
    content_tag(:i, "", class: "fa #{checked ? "fa-check-square-o" : "fa-square-o"}")
  end

  def simple_bold(text)
    sanitize(text.to_s.gsub(/\*\*(.*?)\*\*/, "<strong>\\1</strong>"), tags: %w(strong))
  end
end
