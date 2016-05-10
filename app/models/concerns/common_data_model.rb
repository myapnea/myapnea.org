# frozen_string_literal: true

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
    (weight in pounds from weight/weight)


PRO_CM table
  general-health-rate/general_health_rating     ==>   PN_0001/61577-3
  general-quality-life-rate/general_quality_life_rating     ==>   PN_0002/61578-1
  everyday-physical-activities/everyday_physical_activities     ==>   PN_0003/61582-3
  errands-and-shop/errands_and_shop     ==>   PN_0004/61635-9
  last-week-depression/last_week_depression     ==>   PN_0005/61967-6
  last-week-fatigue/last_week_fatigue     ==>   PN_0006/61878-5
  last-week-problem-sleep/last_week_problem_sleep     ==>   PN_0007/61998-1
  trouble-with-leisure/trouble_with_leisure     ==>   PN_0008/75417-6
  last-week-pain-interference/last_week_pain_interference     ==>   PN_0009/61758-9
=end

module CommonDataModel


  extend ActiveSupport::Concern

  include DateAndTimeParser

  # Helpers

  def pcornet_get_answer(survey_slug, question_slug, encounter)
    survey = Survey.current.viewable.find_by_slug survey_slug
    question = survey.questions.find_by_slug question_slug

    answer_session = self.answer_sessions.where(survey: survey, encounter: encounter).first
    answer = nil
    if survey and question and answer_session
      answer_template = question.answer_templates.first
      answer_value = answer_session.answer_values(question, answer_template).first
      answer = answer_value.answer if answer_value
    end
    answer
  end

  def pcornet_get_response(survey_slug, question_slug, encounter)
    answer = pcornet_get_answer(survey_slug, question_slug, encounter)
    answer ? answer.show_value : nil
  end

  # TEXT(x)
  def pcornet_patid
    self.id.to_s
  end

  ## DEMOGRAPHICS

  # TEXT(10): YYYY-MM-DD or YYYY
  def pcornet_birth_date
    date = parse_date(pcornet_get_response('about-me', 'date-of-birth', 'baseline'))
    date ? date.strftime("%Y-%m-%d") : nil
  end

  # TEXT(x)
  def pcornet_raw_sex
    pcornet_get_response('about-me', 'sex', 'baseline')
  end

  # TEXT(x)
  def pcornet_raw_hispanic
    if pcornet_get_response('about-me', 'ethnicity', 'baseline') == "No"
      nil
    else
      "Hispanic"
    end
  end

  # TEXT(x)
  def pcornet_raw_race
    pcornet_get_response('about-me', 'race', 'baseline')
  end

  ## VITAL

  # TEXT(2)
  def pcornet_vital_source
    'PR' # Patient-reported
  end

  # NUMBER(8) Height in inches
  def pcornet_ht
    pcornet_get_response('additional-information-about-me', 'height', 'baseline')
  end

  def pcornet_ht_measure_date
    if answer = pcornet_get_answer('additional-information-about-me', 'height', 'baseline')
      answer.created_at.strftime("%Y-%m-%d")
    else
      nil
    end
  end

  def pcornet_ht_measure_time
    if answer = pcornet_get_answer('additional-information-about-me', 'height', 'baseline')
      answer.created_at.strftime("%H:%M")
    else
      nil
    end
  end

  # NUMBER(8) Weight in pounds
  def pcornet_wt
    pcornet_get_response('additional-information-about-me', 'weight', 'baseline')
  end

  ## PRO_CM

  # general-health-rate/general_health_rating     ==>   PN_0001/61577-3
  # general-quality-life-rate/general_quality_life_rating     ==>   PN_0002/61578-1
  # everyday-physical-activities/everyday_physical_activities     ==>   PN_0003/61582-3
  # errands-and-shop/errands_and_shop     ==>   PN_0004/61635-9
  # last-week-depression/last_week_depression     ==>   PN_0005/61967-6
  # last-week-fatigue/last_week_fatigue     ==>   PN_0006/61878-5
  # last-week-problem-sleep/last_week_problem_sleep     ==>   PN_0007/61998-1
  # trouble-with-leisure/trouble_with_leisure     ==>   PN_0008/75417-6
  # last-week-pain-interference/last_week_pain_interference     ==>   PN_0009/61758-9


  def pcornet_pn_0001
    pcornet_get_answer('my-quality-of-life', 'general-health-rate', 'baseline')
  end

  def pcornet_pn_0002
    pcornet_get_answer('my-quality-of-life', 'general-quality-life-rate', 'baseline')
  end

  def pcornet_pn_0003
    pcornet_get_answer('my-quality-of-life', 'everyday-physical-activities', 'baseline')
  end

  def pcornet_pn_0004
    pcornet_get_answer('my-quality-of-life', 'errands-and-shop', 'baseline')
  end

  def pcornet_pn_0005
    pcornet_get_answer('my-quality-of-life', 'last-week-depression', 'baseline')
  end

  def pcornet_pn_0006
    pcornet_get_answer('my-quality-of-life', 'last-week-fatigue', 'baseline')
  end

  def pcornet_pn_0007
    pcornet_get_answer('my-quality-of-life', 'last-week-problem-sleep', 'baseline')
  end

  def pcornet_pn_0008
    pcornet_get_answer('my-quality-of-life', 'trouble-with-leisure', 'baseline')
  end

  def pcornet_pn_0009
    pcornet_get_answer('my-quality-of-life', 'last-week-pain-interference', 'baseline')
  end

end
