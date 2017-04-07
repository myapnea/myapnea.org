# frozen_string_literal: true

# Base survey builder class.
class Builder::BuilderController < ApplicationController
  private

  def redirect_non_builders
    empty_response_or_root_path unless current_user.can_build_surveys?
  end

  def find_editable_survey_or_redirect(survey_id = :survey_id)
    @survey = current_user.editable_surveys.find_by_param(params[survey_id])
    redirect_without_survey
  end

  def redirect_without_survey
    empty_response_or_root_path(builder_surveys_path) unless @survey
  end

  def find_editable_question_or_redirect(question_id = :question_id)
    @question = @survey.questions.find_by_param(params[question_id])
    empty_response_or_root_path(builder_survey_path(@survey)) unless @question
  end

  def redirect_without_question
    empty_response_or_root_path(builder_survey_path(@survey)) unless @question
  end

  def find_editable_answer_template_or_redirect(answer_template_id = :answer_template_id)
    @answer_template = @question.answer_templates.find_by(id: params[answer_template_id])
    redirect_without_answer_template
  end

  def redirect_without_answer_template
    empty_response_or_root_path(builder_survey_question_path(@survey, @question)) unless @answer_template
  end

  def find_editable_answer_option_or_redirect(answer_option_id = :answer_option_id)
    @answer_option = @answer_template.answer_options.find_by(id: params[answer_option_id])
    redirect_without_answer_option
  end

  def redirect_without_answer_option
    empty_response_or_root_path(builder_survey_question_answer_template_path(@survey, @question, @answer_template)) unless @answer_option
  end
end
