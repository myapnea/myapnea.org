# frozen_string_literal: true

require 'test_helper'

# Tests for random name generation.
class UserTest < ActiveSupport::TestCase
  def user_params(email: nil)
    {
      forum_name: User.generate_forum_name(email),
      first_name: 'First',
      last_name: 'Last',
      email: email,
      password: 'mynewpassword'
    }
  end

  test 'should generate valid forum names' do
    assert_operator 10, :<=, User.generate_forum_name(nil).size
    assert_operator 10, :<=, User.generate_forum_name('').size
    assert_operator 10, :<=, User.generate_forum_name('test@example.com').size
    u = User.create(user_params(email: 'email@example.com'))
    assert_equal [], u.errors[:forum_name]
    u = User.create(user_params(email: 'email2@example.com'))
    assert_equal [], u.errors[:forum_name]
    u = User.create(user_params(email: 'email3@example.com'))
    assert_equal [], u.errors[:forum_name]
  end

  test 'should have valid animals that only contain two or more letters' do
    User.animals.each do |animal|
      assert_no_match(/[^a-zA-Z]/, animal)
      assert_operator 2, :<=, animal.to_s.size
    end
  end

  test 'should have valid colors that only contain two or more letters' do
    User.colors.each do |color|
      assert_no_match(/[^a-zA-Z]/, color)
      assert_operator 2, :<=, color.to_s.size
    end
  end

  test 'should have valid adjectives that only contain two or more letters' do
    User.adjectives.each do |adjective|
      assert_no_match(/[^a-zA-Z]/, adjective)
      assert_operator 2, :<=, adjective.to_s.size
    end
  end
end
