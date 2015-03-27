create or replace view report_answer_totals as
  select
    s.id as survey_id,
    q.id as question_id,
    ans.encounter as encounter,
    av.answer_template_id as answer_template_id,
    count(av_ao.id) as total_count
  from surveys s
    inner join survey_question_orders sqo on s.id = sqo.survey_id
    inner join questions q on q.id = sqo.question_id
    inner join answer_sessions ans on ans.survey_id = s.id
    inner join answers a on (a.answer_session_id = ans.id and a.question_id = q.id)
    inner join answer_values av on av.answer_id = a.id
    inner join answer_options av_ao on av_ao.id = av.answer_option_id
  group by s.id, q.id, ans.encounter, av.answer_template_id;
