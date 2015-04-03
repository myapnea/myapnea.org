create or replace view report_answer_options as
  select
    s.id as survey_id,
    q.id as question_id,
    q_at.id as answer_template_id,
    q_ao.id as answer_option_id,
    q_ao.text as answer_option
  from questions q
    inner join answer_templates_questions atq on q.id = atq.question_id
    inner join answer_templates q_at on q_at.id = atq.answer_template_id
    inner join answr_options_answer_templates q_aoat on q_aoat.answer_template_id = q_at.id
    inner join answer_options q_ao on q_ao.id = q_aoat.answer_option_id
    inner join survey_question_orders sqo on q.id = sqo.question_id
    inner join surveys s on s.id = sqo.survey_id
  order by s.id, q.id, q_at.id, q_ao.id;
