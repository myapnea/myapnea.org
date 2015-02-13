create or replace view report_answer_counts as
select s.id as survey_id, q.id as question_id, av.answer_template_id as answer_template_id, av_ao.id as answer_option_id, count(coalesce(av_ao.text, av_ao.text_value_en)) as answer_count
from questions q

inner join survey_question_orders sqo on q.id = sqo.question_id
inner join surveys s on s.id = sqo.survey_id

inner join answers a on a.question_id = q.id
inner join answer_values av on av.answer_id = a.id
inner join answer_options av_ao on av_ao.id = av.answer_option_id

group by s.id, q.id, av.answer_template_id,av_ao.id;
