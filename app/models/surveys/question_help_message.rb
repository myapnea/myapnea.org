class QuestionHelpMessage < ActiveRecord::Base
  include Localizable

  include Authority::Abilities
  self.authorizer_name = "OwnerAuthorizer"

  has_many :questions

  localize :message

end
