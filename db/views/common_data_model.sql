/* Demographics */

/* Birth Date */
select u.id, av.text_value from users u
left join answer_sessions ans on ans.user_id = u.id
join answers a on a.answer_session_id = ans.id
join answer_values av on a.id = av.answer_id
join questions q on a.question_id = q.id
join answer_templates_questions qat on qat.question_id = q.id
join answer_templates at on qat.answer_template_id = at.id
where
q.slug = 'date-of-birth' and at.name = 'birth_date';

/* Sex */
select u.id, ao.value, ao.text from users u
left join answer_sessions ans on ans.user_id = u.id
join answers a on a.answer_session_id = ans.id
join answer_values av on a.id = av.answer_id
join answer_options ao on av.answer_option_id = ao.id
join questions q on a.question_id = q.id
join answer_templates_questions qat on qat.question_id = q.id
join answer_templates at on qat.answer_template_id = at.id
where
q.slug = 'sex' and at.name = 'sex';

/* Hispanic Ethnicity */
select u.id, ao.value, ao.text from users u
left join answer_sessions ans on ans.user_id = u.id
join answers a on a.answer_session_id = ans.id
join answer_values av on a.id = av.answer_id
join answer_options ao on av.answer_option_id = ao.id
join questions q on a.question_id = q.id
join answer_templates_questions qat on qat.question_id = q.id
join answer_templates at on qat.answer_template_id = at.id
where
q.slug = 'ethnicity' and at.name = 'ethnicity';

/* Race */
select u.id, ao.value, ao.text from users u
left join answer_sessions ans on ans.user_id = u.id
join answers a on a.answer_session_id = ans.id
join answer_values av on a.id = av.answer_id
join answer_options ao on av.answer_option_id = ao.id
join questions q on a.question_id = q.id
join answer_templates_questions qat on qat.question_id = q.id
join answer_templates at on qat.answer_template_id = at.id
where
q.slug = 'race' and at.name = 'race';

/* Enrollments Table */
select u.id, u.signed_consent_at from users u
left join answer_sessions ans on ans.user_id = u.id


