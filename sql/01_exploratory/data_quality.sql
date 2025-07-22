-- data quality verification algorithm 
select 
    'total prospects' as metric,
    count(*)::text as value,
    'baseline' as assessment
from nba_prospects_2025

union all

select 
    'complete records',
    count(*)::text,
    round(count(*) * 100.0 / (select count(*) from nba_prospects_import), 1)::text || '%'
from nba_prospects_import
where name is not null 
  and position is not null 
  and final_rank is not null
  and ppg is not null

union all

select 
    'anomalies detected',
    count(*)::text,
    case when count(*) = 0 then 'clean' else 'needs review' end
from nba_prospects_import
where final_rank < 1 or final_rank > 60
   or age < 16 or age > 25
   or ppg < 0 or ppg > 40;
