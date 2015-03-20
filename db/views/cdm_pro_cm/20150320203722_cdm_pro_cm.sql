create or replace view cdm_pro_cm as
select ans.user_id patid, ans.encounter encounterid,
       pcornet_unique_id(at.name) pro_item,
       pcornet_loinc(at.name) pro_loinc,
       at.updated_at::date pro_date,
       at.updated_at::time pro_time,
       max(ao.value) pro_response,
       string_agg(ao.text, ',') raw_pro_response,
       'EC'::text pro_method,
       'SF'::text pro_mode,
       'N'::text pro_cat,
       count(a.id) answer_count,
       count(ao.id) answer_option_count,
       count(av.id) answer_value_count,
       bool_and(ans.locked) answer_session_locked,
       string_agg(a.state, ',') answer_state

from answer_sessions ans
  join answers a on a.answer_session_id = ans.id
  join answer_values av on a.id = av.answer_id
  left join answer_options ao on av.answer_option_id = ao.id
  join questions q on a.question_id = q.id
  join answer_templates_questions qat on qat.question_id = q.id
  join answer_templates at on qat.answer_template_id = at.id

where at.name in ('general_health_rating', 'everyday_physical_activities','errands_and_shop', 'last_week_depression', 'last_week_fatigue',
                  'last_week_problem_sleep', 'trouble_with_leisure', 'last_week_pain_interference')
      and ans.deleted = FALSE
      and a.deleted = FALSE
      and av.deleted = FALSE
group by ans.user_id, ans.encounter, at.name, at.updated_at;
