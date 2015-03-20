create or replace view cdm_vital as
select
  ans.user_id patid, ans.encounter encounterid,
  max(a.updated_at::date) measure_date, max(a.updated_at::time) measure_time,
  'PR'::text vital_source,
  max(case when q.slug = 'height' then av.numeric_value end) as ht,
  max(case when q.slug = 'height' then av.updated_at end) as ht_measure_date,
  max(case when q.slug = 'height' then a.state end) as ht_state,
  bool_and(case when q.slug = 'height' then a.preferred_not_to_answer end) as ht_pref_not_to_answer,
  max(case when q.slug = 'weight' then av.numeric_value end) as wt,
  max(case when q.slug = 'weight' then av.updated_at end) as wt_measure_date,
  max(case when q.slug = 'weight' then a.state end) as wt_state,
bool_and(case when q.slug = 'weight' then a.preferred_not_to_answer end) as wt_pref_not_to_answer
from answer_sessions ans
  left join answers a on ans.id = a.answer_session_id
  join answer_values av on av.answer_id = a.id
  join questions q on a.question_id = q.id
where q.slug in ('height', 'weight')
      and ans.deleted = FALSE
      and a.deleted = FALSE
      and av.deleted = FALSE
group by ans.user_id, ans.encounter, ans.locked;
