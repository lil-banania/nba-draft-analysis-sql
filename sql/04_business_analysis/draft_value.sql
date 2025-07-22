
-- goal : determine the value of a draft pick

with draft_tiers as (
    select 
        name,
        final_rank,
        final_gen_probability,
        
        case 
            when final_rank between 1 and 10 then 'lottery (1-10)'
            when final_rank between 11 and 20 then 'mid first (11-20)'
            when final_rank between 21 and 30 then 'late first (21-30)'
            else 'second round (31+)'
        end as draft_tier
        
    from nba_prospects_2025
    where final_rank is not null
)
select 
    draft_tier,
    count(*) as prospects,
    round(avg(final_gen_probability), 3) as avg_potential,
    round(min(final_gen_probability), 3) as worst_in_tier,
    round(max(final_gen_probability), 3) as best_in_tier,
    
    -- simple assessment 
    case 
        when avg(final_gen_probability) > 0.7 then 'high value tier'
        when avg(final_gen_probability) > 0.5 then 'medium value tier'
        else 'low value tier'
    end as tier_assessment
    
from draft_tiers
group by draft_tier
order by avg_potential desc;
