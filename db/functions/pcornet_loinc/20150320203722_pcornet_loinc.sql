create or replace function pcornet_loinc(nm text) returns text as $$
        begin
	  case nm
	    when 'general_health_rating' then return '61577-3';
	    when 'general_quality_life_rating' then return '61578-1';
	    when 'everyday_physical_activities' then return '61582-3';
	    when 'errands_and_shop' then return '61635-9';
	    when 'last_week_depression' then return '61967-6';
	    when 'last_week_fatigue' then return '61878-5';
	    when 'last_week_problem_sleep' then return '61998-1';
	    when 'trouble_with_leisure' then return '75417-6';
	    when 'last_week_pain_interference' then return '61758-9';
	    else return null;
	  end case;
        end;
$$ language plpgsql;
