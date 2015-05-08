require "test_helper"

class SocialProfileTest < ActiveSupport::TestCase

  def social_profile
    @social_profile ||= SocialProfile.new
  end

  def test_valid
    assert social_profile.valid?
  end

  test "should generate valid forum names" do
    assert_operator 10, :<=, SocialProfile.generate_forum_name(nil).size
    assert_operator 10, :<=, SocialProfile.generate_forum_name('').size
    assert_operator 10, :<=, SocialProfile.generate_forum_name('test@example.com').size
    u = User.create(forum_name: SocialProfile.generate_forum_name('email@example.com'), first_name: 'First', last_name: 'Last', email: 'email@example.com', password: 'mynewpassword')
    assert_equal [], u.errors[:forum_name]
    u = User.create(forum_name: SocialProfile.generate_forum_name('email2@example.com'), first_name: 'First', last_name: 'Last', email: 'email2@example.com', password: 'mynewpassword')
    assert_equal [], u.errors[:forum_name]
    u = User.create(forum_name: SocialProfile.generate_forum_name('email3@example.com'), first_name: 'First', last_name: 'Last', email: 'email3@example.com', password: 'mynewpassword')
    assert_equal [], u.errors[:forum_name]
  end

  test "should have valid animals that only contain two or more letters" do
    SocialProfile.animals.each do |animal|
      assert_no_match /[^a-zA-Z]/, animal
      assert_operator 2, :<=, animal.to_s.size
    end
  end

  test "should have valid colors that only contain two or more letters" do
    SocialProfile.colors.each do |color|
      assert_no_match /[^a-zA-Z]/, color
      assert_operator 2, :<=, color.to_s.size
    end
  end

  test "should have valid adjectives that only contain two or more letters" do
    SocialProfile.adjectives.each do |adjective|
      assert_no_match /[^a-zA-Z]/, adjective
      assert_operator 2, :<=, adjective.to_s.size
    end
  end

end
