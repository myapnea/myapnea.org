# frozen_string_literal: true

require "test_helper"

# Tests email confirmations.
class ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @unconfirmed = users(:unconfirmed)
  end

  test "should confirm email and redirect to dashboard" do
    get user_confirmation_url(confirmation_token: @unconfirmed.confirmation_token)
    assert_redirected_to dashboard_url
  end
end
