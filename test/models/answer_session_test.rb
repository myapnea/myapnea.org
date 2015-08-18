require "test_helper"

class AnswerSessionTest < ActiveSupport::TestCase
  test "should unlock answer session" do
    as = answer_sessions(:complete)
    assert as.completed?
    as.lock
    assert as.locked?
    as.unlock!
    refute as.locked?
  end
end
