		 
-- Top 10 Scorers
select name, position, ppg, fta,
	   round(fg_pct,2) as field_goal_percentage,
	   round(three_pt_pct,2) as three_point_pct,
	   round(shooting_skill_score,2) as scorer_score
from nba_prospects_import
where ppg > 14
  and fg_pct > 0.35
  and three_pt_pct > 0.32
  and shooting_skill_score > 0.8
limit 10
