module SurveysHelper
  def have_checked?(answer, answer_template, val)
    if answer.present? and answer.value.present? and answer.value[answer_template.id].present?
      saved_val = answer.value[answer_template.id]

      if saved_val.kind_of?(Array)
        saved_val.include? val
      else
        saved_val == val
      end
    else
      false
    end

  end

  def start_or_resume_survey(survey, answer_session = nil)
    if answer_session.present?
      if answer_session.started? and answer_session.last_answer.next_question.present?
        ask_question_path(answer_session_id: answer_session.id, question_id: answer_session.last_answer.next_question.id)
      else
        ask_question_path(answer_session_id: answer_session.id, question_id: survey.first_question.id)
      end
    else
      intro_survey_path(survey)
    end
  end

  def next_survey_path(survey)
    next_survey = current_user.next_survey(survey)
    next_survey.present? ? survey_path(next_survey) : surveys_path
  end


end
