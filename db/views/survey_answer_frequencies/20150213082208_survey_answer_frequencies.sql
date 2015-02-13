create or replace view survey_answer_frequencies as
select rao.survey_id, rao.question_id, rao.answer_template_id, rao.answer_option_id, rao.answer_option as answer_option_text, coalesce(rac.answer_count, 0) answer_count, coalesce(rat.total_count, 0) total_count, coalesce((rac.answer_count::float / rat.total_count), 0) as frequency
from report_answer_options rao
  left join report_answer_totals rat on rat.survey_id = rao.survey_id and rat.question_id = rao.question_id and rat.answer_template_id = rao.answer_template_id
  left join report_answer_counts rac on rac.survey_id = rao.survey_id and rac.question_id = rao.question_id and rac.answer_template_id = rao.answer_template_id and rac.answer_option_id = rao.answer_option_id;

