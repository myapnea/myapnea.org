class QuestionsController < ApplicationController
  def self.model_class
    Question
  end

  before_filter :authenticate_user!


  def frequencies
    question = Question.find(params[:question_id])
    @user_answer = question.user_answer(@answer_session)
    @answer_frequencies = question.answer_frequencies
  end

  def typeahead
    @question = Question.find(params[:question_id])

  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def object_params
    params.require(:question).permit(:text, :question_type_id, :question_help_message, :answer_type_id, :time_estimate)
  end
end
