WITH age_performance AS (
    SELECT 
        position,
        -- Create age groups for more granularity
        floor(age * 2) / 2 as age_bracket, 
        count(*) as prospects,
        round(AVG(final_gen_probability), 3) as avg_potential,
        round(AVG(ppg), 1) as avg_production,
        string_agg(name, ', ' order by final_gen_probability desc) as prospect_names
    from nba_prospects_import
    where age IS NOT NULL 
      and final_gen_probability IS NOT NULL 
      and position IS NOT NULL
    group by position, floor(age * 2) / 2
    having count(*) >= 1
),
position_age_ranking as (
    select *,
        -- Ranking by each age groups
        row_number() over (partition by position order by avg_potential desc) as potential_rank,
         row_number() over (partition by position order by avg_production desc) as production_rank
    FROM age_performance
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
        when potential_rank = 1 then ' Potential Sweet Spot'
        when potential_rank = 2 then 'Great age'
        when potential_rank <= 3 then 'Correct'
        else 'Less optimal'
    end as age_assessment,
    
    prospect_names
from position_age_ranking
where potential_rank <= 4  -- TOP 4 by each age category
order by position, potential_rank;
