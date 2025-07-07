-- Goal is to find the best age per position
with age_performance as (
    select 
        position,
        floor(age * 2) / 2 as age_bracket,
        count(*) as prospects,
        round(avg(final_gen_probability), 3) as avg_potential,
        round(avg(ppg), 1) as avg_production,
        string_agg(name, ', ' order by final_gen_probability desc) as prospect_names
    from nba_prospects_import
    where age is not null
      and final_gen_probability is not null
      and position is not null
group by position, FLOOR(age * 2) / 2
  having count(*) >= 1
),
position_age_ranking as (
    select *,
        row_number OVER (PARTITION by position order by avg_potential desc) as potential_rank,
        row_number() OVER (PARTITION by position order by avg_production DESC) as production_rank
    from age_performance
)
select 
    position,
    age_bracket as optimal_age,
    prospects,
    avg_potential,
    avg_production,
    potential_rank,
    
    -- Assessment
    case 
        when potential_rank = 1 then 'Sweet Spot Potentiel'
        when potential_rank = 2 then ' Great Age'
        when potential_rank <= 3 then 'Correct'
        else 'Less Optimal'
    end as age_assessment,
    
    prospect_names
from position_age_ranking
where potential_rank <= 4  -- top 4
order by position, potential_rank;
