class SurveyAnswerFrequency < ActiveRecord::Base
  belongs_to :question_flow
  belongs_to :question
  belongs_to :answer_option


end
