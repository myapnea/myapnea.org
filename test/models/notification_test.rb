require "test_helper"

class NotificationTest < ActiveSupport::TestCase

  def notification
    @notification ||= Notification.new
  end

  def test_valid
    assert notification.valid?
  end

end
