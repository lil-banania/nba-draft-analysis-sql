-- Backcourt focus view allow to get the main informations about the guards in the draft

create or replace view backcourt_focus as 

select name, position, age,final_rank,
			 round(ppg,1) as ppg,
			 round(apg,1) as apg,
			 round(usage_rate_calculated,2) as usage_rate,
			 round(fg_pct,2) as field_goal_pct,
 			 round (ts_pct,2) as true_shooting_pct,
			 round(three_pt_pct,2) as three_pt_pct,
			 round(final_gen_probability,2) as final_gen,
			 is_generational_talent
from nba_prospects_import
where position in ('PG','PG/SG', 'PG/SF', 'SG', 'SG/SF')
order by ppg desc
