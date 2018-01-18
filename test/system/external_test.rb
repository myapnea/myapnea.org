# frozen_string_literal: true

require "application_system_test_case"

# System tests for external pages.
class ExternalTest < ApplicationSystemTestCase
  test "visit landing page" do
    visit root_url
    screenshot("visit-landing-page")
    find("a[href='#research']").click
    sleep(0.5) # Allow time to setup canvas for drawing
    screenshot("visit-landing-page")
    find("a[href='#join']").click
    sleep(0.5) # Allow time to setup canvas for drawing
    screenshot("visit-landing-page")
  end

  test "visit about page" do
    visit about_url
    screenshot("visit-about-page")
    page.execute_script("window.scrollBy(0, $(\"body\").height());")
    screenshot("visit-about-page")
  end

  test "visit partners page" do
    visit partners_url
    screenshot("visit-partners-page")
  end

  test "visit team page" do
    visit team_url
    screenshot("visit-team-page")
  end

  test "visit blog" do
    visit blog_url
    screenshot("visit-blog")
    assert_selector "h1", text: "Blog"
    # Add if blog extends beyond bottom of browser.
    # page.execute_script("window.scrollBy(0, $(\"body\").height());")
    # screenshot("visit-blog")
  end

  test "visit forum" do
    visit topics_url
    screenshot("visit-forum")
    assert_selector "h1", text: "Forum"
    # Add if forum extends beyond bottom of browser.
    # page.execute_script("window.scrollBy(0, $(\"body\").height());")
    # screenshot("visit-forum")
  end

  test "visit research page" do
    visit slice_research_url
    screenshot("visit-research-page")
    assert_selector "h1", text: "Research"
  end

  test "visit search page" do
    visit search_url
    screenshot("visit-search-page")
    assert_selector "h1", text: "Help Center"
  end
end
