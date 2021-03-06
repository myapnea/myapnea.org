# frozen_string_literal: true

require "test_helper"

# Tests for random name generation.
class UserTest < ActiveSupport::TestCase
  def user_params(email: nil)
    {
      username: User.suggest_username(email),
      full_name: "First Last",
      email: email,
      password: "mynewpassword"
    }
  end

  test "should only create valid user" do
    user = User.create
    assert_equal ["can't be blank"], user.errors[:username]
    assert_equal ["can't be blank"], user.errors[:email]
    assert_equal ["can't be blank"], user.errors[:password]
  end

  test "should generate valid usernames" do
    assert_operator 6, :<=, User.suggest_username("").size
    assert_operator 6, :<=, User.suggest_username("test@example.com").size
    u = User.create(user_params(email: "email@example.com"))
    assert_equal [], u.errors[:username]
    u = User.create(user_params(email: "email2@example.com"))
    assert_equal [], u.errors[:username]
    u = User.create(user_params(email: "email3@example.com"))
    assert_equal [], u.errors[:username]
  end

  test "should have valid animals that only contain two or more letters" do
    User.animals.each do |animal|
      assert_no_match(/[^a-zA-Z]/, animal)
      assert_operator 2, :<=, animal.to_s.size
    end
  end

  test "should have valid colors that only contain two or more letters" do
    User.colors.each do |color|
      assert_no_match(/[^a-zA-Z]/, color)
      assert_operator 2, :<=, color.to_s.size
    end
  end
end
