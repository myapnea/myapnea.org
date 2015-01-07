class SurveyQuestionOrder < ActiveRecord::Base
  belongs_to :question
  belongs_to :question_flow
end
