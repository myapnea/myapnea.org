select qf.id as question_flow_id, q.id as question_id, count(av_ao.id) as total_count
from questions q

  inner join survey_question_orders sqo on q.id = sqo.question_id
  inner join question_flows qf on qf.id = sqo.question_flow_id

  inner join answers a on a.question_id = q.id
  inner join answer_values av on av.answer_id = a.id
  inner join answer_options av_ao on av_ao.id = av.answer_option_id
group by qf.id, q.id;
