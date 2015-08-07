class UserAuthorizer < ApplicationAuthorizer
  def self.updatable_by?(user)
    user.owner?
  end

  def self.readable_by?(user)
    user.owner?
  end

  def self.deletable_by?(user)

    user.owner?
  end

  def updatable_by?(user)
    resource == user
  end

  def readable_by?(user)
    resource == user
  end

end