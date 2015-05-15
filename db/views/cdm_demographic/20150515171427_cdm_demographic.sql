create or replace view cdm_demographic as
select u.id patid,
       max(case when q.slug = 'date-of-birth' and at.name = 'birth_date'  then av.text_value end) as birth_date,

       array_agg(case when q.slug = 'sex' and at.name = 'sex' then ao.text end) as raw_sex_text,
       array_agg(case when q.slug = 'sex' and at.name = 'sex' then ao.value::text end) as raw_sex_value,
       max(case when q.slug = 'sex' and at.name = 'sex' then av.updated_at end) as sex_measure_date,
       max(case when q.slug = 'sex' and at.name = 'sex' then a.state end) as sex_state,
       count(case when q.slug = 'sex' and at.name = 'sex' then ao.value end) as sex_count,

       array_agg(case when q.slug = 'ethnicity' and at.name = 'ethnicity' then ao.text end) as raw_hispanic_text,
       array_agg(case when q.slug = 'ethnicity' and at.name = 'ethnicity' then ao.value::text end) as raw_hispanic_value,
       max(case when q.slug = 'ethnicity' and at.name = 'ethnicity' then av.updated_at end) as ethnicity_measure_date,
       max(case when q.slug = 'ethnicity' and at.name = 'ethnicity' then a.state end) as ethnicity_state,
       count(case when q.slug = 'ethnicity' and at.name = 'ethnicity' then ao.value end) as ethnicity_count,

       array_agg(case when q.slug = 'race' and at.name = 'race' then ao.text end) as raw_race_text,
       array_agg(case when q.slug = 'race' and at.name = 'race' then ao.value::text end) as raw_race_value,
       max(case when q.slug = 'race' and at.name = 'race' then av.updated_at end) as race_measure_date,
       max(case when q.slug = 'race' and at.name = 'race' then a.state end) as race_state,
       count(case when q.slug = 'race' and at.name = 'race' then ao.value end) as race_count,
       count(ans.id) answer_session_count,
       array_agg(ans.encounter) encounters

from users u
  left join answer_sessions ans on ans.user_id = u.id
  join answers a on a.answer_session_id = ans.id
  join answer_values av on a.id = av.answer_id
  left join answer_options ao on av.answer_option_id = ao.id
  join questions q on a.question_id = q.id
  join answer_templates_questions qat on qat.question_id = q.id
  join answer_templates at on qat.answer_template_id = at.id

where q.slug in ('ethnicity', 'race', 'sex', 'date-of-birth')
      and ans.deleted = FALSE
      and a.deleted = FALSE
      and av.deleted = FALSE
      and u.include_in_exports = TRUE
group by u.id;
