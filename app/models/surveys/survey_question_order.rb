class SurveyQuestionOrder < ActiveRecord::Base
  belongs_to :survey, -> { current }
  belongs_to :question, -> { current }
end
