select *
from answer_values av
join answer_options av_ao on av_ao.id = av.answer_option_id
join answer_templates av_at on av_at.id = av.answer_template_id
join answers a on av.answer_id = a.id
join answer_sessions ans on ans.id = a.answer_session_id
join users u on ans.user_id = u.id
join surveys s on s.id = ans.survey_id;


