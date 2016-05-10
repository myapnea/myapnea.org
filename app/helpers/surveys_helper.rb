# frozen_string_literal: true

module SurveysHelper
  def have_checked?(answer, answer_template, val)
    if answer.present? and answer.value.present? and answer.value[answer_template.id].present?
      saved_val = answer.value[answer_template.id]

      if saved_val.is_a?(Array)
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
    next_answer_session ? show_survey_path(next_answer_session.survey, answer_session.encounter) : surveys_path
  end

  def next_child_answer_session_path(answer_session)
    next_answer_session = current_user.next_child_answer_session(answer_session)
    next_answer_session ? child_survey_path(next_answer_session.child.id, next_answer_session.survey, next_answer_session.encounter) : surveys_path
  end

end
