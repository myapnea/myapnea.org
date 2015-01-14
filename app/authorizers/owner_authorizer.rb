class OwnerAuthorizer < ApplicationAuthorizer
  def self.readable_by?
    user_signed_in?
  end

  def self.createable_by?
    user.has_role? :owner

  end

  def self.updateable_by?
    user.has_role? :owner

  end

  def self.deletable_by?
    user.has_role? :owner

  end


end
