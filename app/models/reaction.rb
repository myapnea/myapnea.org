# frozen_string_literal: true

class Reaction < ApplicationRecord
  # Default Scope
  # Constants
  FORM_LIKE = 'like'
  FORM_DISLIKE = 'dislike'
  FORM_REQUEST = 'request_expert_comment'

  # Attribute related macros
  # Associations
  belongs_to :post
  belongs_to :user

  # Validations
  validates :post_id, presence: true

  # Callback
  # Other macros
  # Concerns
  include Deletable

  # Scopes
  scope :likes, -> { where(form: "#{FORM_LIKE}") }
  scope :requests, -> { where(form: "#{FORM_REQUEST}") }

  # Methods
  def group_by_criteria
    # created_at.strftime("%A") # For Monday..Sunday
    created_at.strftime("%u") # For 1..7
  end

  def sort_by_weekdays
    group_by(&:group_by_criteria).map {|k,v| [k, v.length]}.sort
  end
end
