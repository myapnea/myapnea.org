/* REPORTS */

/* Country for Reports */
select u.id, av.text_value, ao.value, ao.text from users u
left join answer_sessions ans on ans.user_id = u.id
join answers a on a.answer_session_id = ans.id
join answer_values av on a.id = av.answer_id
left join answer_options ao on av.answer_option_id = ao.id
join questions q on a.question_id = q.id
join answer_templates_questions qat on qat.question_id = q.id
join answer_templates at on qat.answer_template_id = at.id
where
q.slug = 'origin-country' and at.name = 'specified_country'
group by u.id;

/* Language - only categorical */
select u.id, av.text_value, ao.value, ao.text from users u
left join answer_sessions ans on ans.user_id = u.id
join answers a on a.answer_session_id = ans.id
join answer_values av on a.id = av.answer_id
left join answer_options ao on av.answer_option_id = ao.id
join questions q on a.question_id = q.id
join answer_templates_questions qat on qat.question_id = q.id
join answer_templates at on qat.answer_template_id = at.id
where
q.slug = 'primary-language' and at.name = 'specified_language';


/***/

select q.id, avg(av.numeric_value) from questions q
left join answers a on a.question_id = q.id
join answer_values av on a.id = av.answer_id
join answer_templates ant on av.answer_template_id = ant.id
where q.id = 493
and ant.id = 6
av.numeric_value is not null
group by q.id



/* Birth Date */
select u.id, av.text_value from users u
left join answer_sessions ans on ans.user_id = u.id
join answers a on a.answer_session_id = ans.id
join answer_values av on a.id = av.answer_id
join questions q on a.question_id = q.id
join answer_templates_questions qat on qat.question_id = q.id
join answer_templates at on qat.answer_template_id = at.id
where
q.slug = 'date-of-birth' and at.name = 'birth_date' and u.id in (

select u.id from users u
left join answer_sessions ans on ans.user_id = u.id
join surveys s on ans.survey_id = s.id where s.slug = 'my-interest-in-research'
and ans.locked = TRUE
);



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

/* Demographics Table */
select u.id patid
 