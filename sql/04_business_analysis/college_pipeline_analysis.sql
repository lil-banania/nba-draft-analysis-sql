-- Goal : determine which college is send more players in NBA 

with college_analysis as (
    select 
        college,
        count(*) as prospects_produced,
        round(avg(final_gen_probability), 3) as avg_talent_level,
        round(avg(final_rank), 1) as avg_draft_position,
        round(avg(ppg), 1) as avg_production,
        string_agg(name, ', ' order by final_gen_probability desc) as prospects_list
        
    from nba_prospects_2025
    where college is not null
    group by college
    having count(*) >= 2  -- at least 2
)
select 
    college,
    prospects_produced,
    avg_talent_level,
    avg_draft_position,
    avg_production,
    
    -- college assessment
    case 
        when prospects_produced >= 4 and avg_talent_level > 0.6 
        then 'elite pipeline'
        when prospects_produced >= 3 and avg_talent_level > 0.5 
        then 'strong pipeline'
        when prospects_produced >= 2 
        then 'decent pipeline'
        else 'limited pipeline'
    end as pipeline_strength,
    
    prospects_list
    
from college_analysis
order by avg_talent_level desc, prospects_produced desc;
