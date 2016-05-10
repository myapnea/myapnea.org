# frozen_string_literal: true

require 'test_helper'

class TopicTest < ActiveSupport::TestCase

  def topic
    @topic ||= users(:user_1).topics.where(forum_id: forums(:one).id).new(name: 'My New Topic', description: 'My First Post on My New Topic')
  end

  def test_valid
    assert topic.valid?
  end

end
