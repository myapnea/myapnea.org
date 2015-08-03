class Builder::BuilderController < ApplicationController

  private

    def redirect_non_builders
      empty_response_or_root_path unless current_user.can_build_surveys?
    end

    def set_editable_survey(survey_id = :survey_id)
      @survey = current_user.editable_surveys.find_by_param(params[survey_id])
    end

    def redirect_without_survey
      empty_response_or_root_path(builder_surveys_path) unless @survey
    end

    def set_editable_question(question_id = :question_id)
      @question = @survey.questions.find_by_param(params[question_id])
    end

    def redirect_without_question
      empty_response_or_root_path(builder_survey_path(@survey)) unless @question
    end

    def set_editable_answer_template(answer_template_id = :answer_template_id)
      @answer_template = @question.answer_templates.find_by_id(params[answer_template_id])
    end

    def redirect_without_answer_template
      empty_response_or_root_path(builder_survey_question_path(@survey, @question)) unless @answer_template
    end

end
