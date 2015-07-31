class SurveyQuestionOrder < ActiveRecord::Base
  belongs_to :question, -> { current }
  belongs_to :survey, -> { current }
end
