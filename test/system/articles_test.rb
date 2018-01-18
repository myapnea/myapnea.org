# frozen_string_literal: true

require "application_system_test_case"

# System tests for articles, faqs, and blogs.
class ArticlesTest < ApplicationSystemTestCase
  # test "visit articles" do
  # end

  test "visit blog" do
    visit blog_url
    screenshot("visit-blog")
    # page.execute_script("window.scrollBy(0, $(\"body\").height());")
    # screenshot("visit-blog")
  end

  test "visit blog post" do
    visit blog_post_url(broadcasts(:published).url_hash)
    screenshot("visit-blog-post")
  end

  # test "visit faqs" do
  # end
end
