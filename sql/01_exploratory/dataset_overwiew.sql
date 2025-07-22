    select  position, 
    count(*) as number_of_players,
    count(DISTINCT country) as number_of_countries,
    round(avg(age), 2) as avg_age,
    round(avg(ppg), 2) as average_ppg,
    max(ppg) as max_ppg,
    min(ppg) as min_ppg,
    round(avg(apg), 2) as average_apg,
    round(avg(rpg), 2) as average_rpg,
    round(avg(final_gen_probability), 2) as average_general
from nba_prospects_2025
where ppg IS NOT NULL
  and apg IS NOT NULL
  and rpg IS NOT NULL
  and final_gen_probability IS NOT NULL
group by position
