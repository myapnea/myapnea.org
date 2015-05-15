create or replace view reports as
  select
    av.id as answer_value_id,
    av_ao.id as answer_option_id,
    av_at.id as answer_template_id,
    a.id as answer_id,
    q.id as question_id,
    ans.id as answer_session_id,
    u.id as user_id,
    s.id as survey_id,
    coalesce(av.numeric_value::text, av.text_value::text, av.time_value::text, av_ao.value::text) as value,
    av_ao.text as answer_option_text,
    a.state as answer_state,
    a.preferred_not_to_answer as preferred_not_to_answer,
    ans.encounter as encounter,
    ans.locked as locked,
    s.slug as survey_slug,
    s.status as survey_status,
    q.slug as question_slug,
    q.display_type as question_display_type,
    av_at.name as answer_template_name,
    av_at.text as answer_template_text,
    av_at.target_answer_option as target_answer_option,
    av_at.allow_multiple as allow_multiple,
    av_at.data_type as data_type,
    av.created_at as created_at,
    av.updated_at as updated_at,
    u.email as user_email,
    u.created_at as user_created_at,
    u.accepted_consent_at as user_accepted_consent_at,
    u.accepted_privacy_policy_at as user_accepted_privacy_policy_at,
    u.accepted_terms_of_access_at as user_accepted_terms_of_access_at,
    u.provider as user_is_provider,
    u.researcher as user_is_researcher,
    u.adult_diagnosed as user_is_adult_diagnosed,
    u.adult_at_risk as user_is_adult_at_risk,
    u.caregiver_adult as user_is_caregiver_adult,
    u.caregiver_child as user_is_caregiver_child
  from answer_values av
    full outer join answer_options av_ao on av_ao.id = av.answer_option_id
    join answer_templates av_at on av_at.id = av.answer_template_id
    join answers a on av.answer_id = a.id
    join questions q on a.question_id = q.id
    join answer_sessions ans on ans.id = a.answer_session_id
    join users u on ans.user_id = u.id
    join surveys s on s.id = ans.survey_id
  where av.deleted = false and a.deleted = false and ans.deleted = false and u.deleted = false and u.include_in_exports = true;
