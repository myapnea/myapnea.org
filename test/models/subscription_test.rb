# frozen_string_literal: true

require 'test_helper'

class SubscriptionTest < ActiveSupport::TestCase

  def subscription
    @subscription ||= Subscription.new(user_id: users(:user_3).id, topic_id: topics(:one).id)
  end

  def test_valid
    assert subscription.valid?
  end

end
