class OwnerAuthorizer < ApplicationAuthorizer
  def self.readable_by?
    user_signed_in?
  end

  def self.createable_by?
    user.owner?

  end

  def self.updateable_by?
    user.owner?

  end

  def self.deletable_by?
    user.owner?

  end


end
