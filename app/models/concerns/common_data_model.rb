module CommonDataModel
  extend ActiveSupport::Concern

  # Helpers

  def pcornet_get_answer(survey_id, question_id)
    survey_id = survey_id
    question = Question.find_by_id question_id

    answer_session = AnswerSession.most_recent(survey_id, self.id)
    answer = question.user_answer(answer_session) if answer_session
    answer
  end

  def pcornet_get_response(survey_id, question_id)
    answer = pcornet_get_answer(survey_id, question_id)
    answer ? answer.show_value : nil
  end

  # TEXT(x)
  def pcornet_patid
    self.id.to_s
  end

  ## DEMOGRAPHICS

  # TEXT(10): YYYY-MM-DD or YYYY
  def pcornet_birth_date
    begin
      pcornet_get_response(16, 578).strftime("%Y-%m-%d")
    rescue
      nil
    end
  end

  # TEXT(x)
  def pcornet_raw_sex
    pcornet_get_response(16, 546)
  end

  # TEXT(x)
  def pcornet_raw_hispanic
    # pcornet_get_response(16, 552) # Original Question
    answer = pcornet_get_answer(16,551)
    if answer and answer.answer_values.pluck(:answer_option_id).include?(9913)
      "Hispanic"
    else
      nil
    end
  end

  # TEXT(x)
  def pcornet_raw_race
    answer = pcornet_get_answer(16, 551)
    values = []
    if answer
      values = answer.answer_values.map(&:show_value)
    end

    (values + [pcornet_get_response(16, 1551)]).flatten.compact
  end

  ## VITAL

  # TEXT(2)
  def pcornet_vital_source
    'PR' # Patient-reported
  end

  # NUMBER(8) Height in inches
  def pcornet_ht
    answer = pcornet_get_answer(16, 547)
    if answer
      height_in_feet = answer.answer_values.where( answer_template_id: 8 ).first
      height_in_inches = answer.answer_values.where( answer_template_id: 9 ).first
      begin
        height_in_feet.value * 12 + height_in_inches.value
      rescue
        nil
      end
    end
  end

  def pcornet_ht_measure_date
    if answer = pcornet_get_answer(16, 547)
      answer.created_at.strftime("%Y-%m-%d")
    else
      nil
    end
  end

  def pcornet_ht_measure_time
    if answer = pcornet_get_answer(16, 547)
      answer.created_at.strftime("%H:%M")
    else
      nil
    end
  end

  # NUMBER(8) Weight in pounds
  def pcornet_wt
    pcornet_get_response(16, 548)
  end


  ## PRO_CM

  def pcornet_pn_0001
    pcornet_get_answer(16, 529)
  end

  def pcornet_pn_0002
    pcornet_get_answer(16, 570)
  end

  def pcornet_pn_0003
    pcornet_get_answer(16, 571)
  end

  def pcornet_pn_0004
    pcornet_get_answer(16, 572)
  end

  def pcornet_pn_0005
    pcornet_get_answer(16, 573)
  end

  def pcornet_pn_0006
    pcornet_get_answer(16, 574)
  end

  def pcornet_pn_0007
    pcornet_get_answer(16, 575)
  end

  def pcornet_pn_0008
    pcornet_get_answer(16, 576)
  end

  def pcornet_pn_0009
    pcornet_get_answer(16, 577)
  end

end
