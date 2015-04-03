create or replace view survey_encounters as
  select
    s.id as survey_id,
    ans.encounter as encounter
  from surveys s
    inner join answer_sessions ans on ans.survey_id = s.id
  group by s.id, ans.encounter
  order by survey_id, encounter;
