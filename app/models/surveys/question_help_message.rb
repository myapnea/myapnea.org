# frozen_string_literal: true

class QuestionHelpMessage < ApplicationRecord
  include Localizable

  has_many :questions

  localize :message

end
