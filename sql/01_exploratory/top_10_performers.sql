select 'top scorers' as category, name, position, ppg as stat_value
from nba_prospects_import
where ppg is not null
order by ppg desc limit 10

union all

select 'top shooters', name, position, three_pt_pct
from nba_prospects_import  
where three_pt_pct is not null
order by three_pt_pct desc limit 10

union all

select 'top potential', name, position, final_gen_probability
from nba_prospects_import
order by final_gen_probability desc limit 10;
