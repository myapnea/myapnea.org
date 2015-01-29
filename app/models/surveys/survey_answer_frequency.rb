class SurveyAnswerFrequency < ActiveRecord::Base
  belongs_to :survey
  belongs_to :question
  belongs_to :answer_option


end
