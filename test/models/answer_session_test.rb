require "test_helper"

class AnswerSessionTest < ActiveSupport::TestCase
  test "#position" do
    # Assigned already manually
    assert_equal surveys(:new).default_position, answer_sessions(:launched).position

    # Unassigned
    assert_equal surveys(:new).default_position, answer_sessions(:incomplete).position

  end

  test "#unlock" do
    as = answer_sessions(:complete)

    assert as.completed?
    as.lock
    assert as.locked?

    as.unlock!

    refute as.locked?


  end
end
