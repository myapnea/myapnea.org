create or replace view survey_answer_frequencies as
select rao.question_flow_id, rao.question_id, rao.answer_option_id, rao.answer_option as answer_option_text, coalesce(rac.answer_count, 0) answer_count, coalesce(rat.total_count, 0) total_count, coalesce((rac.answer_count::float / rat.total_count), 0) as frequency
from report_answer_options rao
  left join report_answer_totals rat on rat.question_flow_id = rao.question_flow_id and rat.question_id = rao.question_id
  left join report_answer_counts rac on rac.question_flow_id = rao.question_flow_id and rac.question_id = rao.question_id and rac.answer_option_id = rao.answer_option_id;

