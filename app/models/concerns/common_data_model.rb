=begin
DOCUMENTATION

Demographics table

- user_id --> text
- birth_date --> text(10) as YYYY-MM-DD
    (from question: date-of-birth/birth_date)
- birth_time --> DNE
- sex --> text(2)
    (from question: sex/sex)

    A=Ambiguous
    F=Female (2)
    M=Male (1)
    NI=No information (4)
    UN=Unknown (Default?)
    OT=Other (3)

- hispanic --> text(2)
    (from question ethnicity/ethnicity)

    Y=Yes (2,3,4,5)
    N=No (1)
    R=Refuse to answer (7)
    NI=No information
    UN=Unknown (6)
    OT=Other

- race --> text(2)
    (from question race/race)

    01=American Indian or Alaska Native (1)
    02=Asian (2)
    03=Black or African American (3)
    04=Native Hawaiian or Other Pacific Islander (4)
    05=White (5)
    06=Multiple race (if more than 1 answer)
    07=Refuse to answer (8)
    NI=No information
    UN=Unknown (7)
    OT=Other (6)

Enrollments table

- user_id --> text
- enr_start_date --> text(10) (YYYY-MM-DD)
    (minimum from all answer_sessions)
- enr_end_date --> text(10) (YYYY-MM-DD)
    (maximum from all answer_sessions)
    OR
    (if consent signed, today's date)
- enr_basis --> text(1)
    A=Algorithmic
    OR
    E=Encounter-based

Encounter table

- user_id --> text
    (from answer_session)
- encounter_id --> text
    (name of encounter in answer_session)
- admit_date --> text(10) (YYYY-MM-DD)
    (answer session creation date OR first answer date)
- admit_time --> text(5) (HH:MI OR first answer time)
- discharge_date --> text(10) (YYYY-MM-DD)
    (most recent answer updated_at if answer session finished?)
- enc_type --> text(2)
    (OT - OTHER)


Vital Table
- patid --> text
- encounterid --> text
    (answer session encounter)
- measure_date --> text(10) (YYYY-MM-DD)
    (answer updated_at)
- measure_time --> text(5) (HH:MI)
    (answer update_at)
- vital_source --> text(2)
    (PR - Patient reported)
- ht --> number(8)
    (height in inches from question height/height)
- wt --> number(8)
    (weight in inches from weight/weight)


=end

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
