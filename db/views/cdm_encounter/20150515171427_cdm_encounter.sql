create or replace view cdm_encounter as
select
  ans.user_id patid,
  ans.encounter encounterid,
  ans.created_at::date admit_date,
  ans.created_at::time,
  max(a.updated_at)::date,
  max(a.updated_at)::time discharge_time,
  'OT'::text as enc_type,
  ans.id as raw_answer_session_id,
  ans.locked
from answer_sessions ans
  left join answers a on ans.id = a.answer_session_id
  join users u on ans.user_id = u.id
where ans.deleted = FALSE
      and a.deleted = FALSE
      and u.include_in_exports = TRUE
group by ans.user_id, ans.encounter, ans.created_at, ans.locked, ans.id;
