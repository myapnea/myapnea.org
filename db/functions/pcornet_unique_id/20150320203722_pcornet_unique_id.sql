create or replace function pcornet_unique_id(nm text) returns text as $$
        begin
	  case nm
	    when 'general_health_rating' then return 'PN_0001';
	    when 'general_quality_life_rating' then return 'PN_0002';
	    when 'everyday_physical_activities' then return 'PN_0003';
	    when 'errands_and_shop' then return 'PN_0004';
	    when 'last_week_depression' then return 'PN_0005';
	    when 'last_week_fatigue' then return 'PN_0006';
	    when 'last_week_problem_sleep' then return 'PN_0007';
	    when 'trouble_with_leisure' then return 'PN_0008';
	    when 'last_week_pain_interference' then return 'PN_0009';
	    else return null;
	  end case;
        end;
$$ language plpgsql;
