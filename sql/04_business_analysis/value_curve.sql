
-- step 1 : Create draft tiers
with draft_tiers as (
    select 
        name,
        final_rank,
        final_gen_probability,
        
        -- Creation of the tiers logic
        case 
            when final_rank between 1 and 5 then '01-05: Elite Tier'
            when final_rank between 6 and 10 then '06-10: Star Tier'  
            when final_rank between 11 and 15 then '11-15: Starter Tier'
            when final_rank between 16 and 20 then '16-20: Role Player Tier'
            when final_rank between 21 and 30 then '21-30: Late First'
            when final_rank between 31 and 45 then '31-45: Early Second'
            else '46-60: Late Second'
        end as draft_tier,
        
        -- Order tier for better ordering 
        case 
            when final_rank between 1 and 5 then 1
            when final_rank between 6 and 10 then 2
            when final_rank between 11 and 15 then 3
            when final_rank between 16 and 20 then 4
            when final_rank between 21 and 30 then 5
            when final_rank between 31 and 45 then 6
            else 7
        end as tier_number
        
    from nba_prospects_import
    where final_rank is not null  
      and final_gen_probability is not null
),

-- step 2 : Calculate stats per tiers
tier_analysis as (
    select 
        draft_tier,
        tier_number,
        count(*) as prospects_in_tier,
        
        -- average value
        round(AVG(final_gen_probability), 3) as avg_potential,
        
        -- tier dispersion
        round(STDDEV(final_gen_probability), 3) as potential_stddev,
        round(MIN(final_gen_probability), 3) as min_potential,
        round(MAX(final_gen_probability), 3) as max_potential,
        
        -- Prospects examples
       string_agg(name || ' (' || ROUND(final_gen_probability, 2) || ')', 
                   ', ' order by final_gen_probability desc) as top_prospects
        
    from draft_tiers
    group by draft_tier, tier_number
),

-- step 3 : calculate the drop between tier
value_drops as (
    select *,
        -- Previous tier potential (LAG)
        LAG(avg_potential) over (order by tier_number) as prev_tier_potential,
        
        -- Drop between tiers
        LAG(avg_potential) over (order by tier_number) - avg_potential as absolute_drop,
        
        -- Drop in percentage
        ROUND(
            (LAG(avg_potential) over (order by tier_number) - avg_potential) / 
            NULLIF(LAG(avg_potential) over (order by tier_number), 0) * 100, 1
        ) as percentage_drop
        
    from tier_analysis
)

select 
    draft_tier,
    prospects_in_tier,
    avg_potential,
    potential_stddev as variability,
    
    -- Tier range
    min_potential || ' - ' || max_potential as potential_range,
    
    -- drop vs previous tier
    coalesce(ROUND(absolute_drop, 3), 0) as drop_from_previous,
    coalesce(percentage_drop, 0) || '%' as percentage_drop,
    
    -- drop assesment
    CASE 
        when percentage_drop > 20 then 'CLIFF: Huge drop'
        when percentage_drop > 10 then 'DROP: Notable drop' 
        when percentage_drop > 5 then 'Decline: Gradually dropping'
        when percentage_drop is null then 'TOP: Elite tier'
        else 'FLAT'
    end as value_assessment,
    
    top_prospects
    
from value_drops
order by tier_number;