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

  def next_answer_session_path(answer_session)
    next_answer_session = current_user.next_answer_session(answer_session)
    next_answer_session ? survey_path(next_answer_session.survey, answer_session.encounter) : surveys_path
  end

end
