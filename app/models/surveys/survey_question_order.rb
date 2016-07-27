# frozen_string_literal: true

class SurveyQuestionOrder < ApplicationRecord
  belongs_to :survey, -> { current }
  belongs_to :question, -> { current }
end
