create or replace view cdm_enrollment as
select
  u.id patid,
  max(u.accepted_consent_at),
  min(ans.created_at) enr_start_date,
  max(a.updated_at) enr_end_date,
  'E'::text as enr_basis
from users u
  left join answer_sessions ans on ans.user_id = u.id
  left join answers a on ans.id = a.answer_session_id
where ans.deleted = FALSE
      and a.deleted = FALSE
      and u.include_in_exports = TRUE
group by u.id;
