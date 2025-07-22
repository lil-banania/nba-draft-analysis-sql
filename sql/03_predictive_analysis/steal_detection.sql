-- step 1: value score calculation
with base_value as (
    select 
        name,
        position,
        final_rank,
        age,
        final_gen_probability,
        ppg,
        three_pt_pct,
        ts_pct,
        
        -- basic value score calculation 
        round((final_gen_probability * 100 / nullif(final_rank, 0)), 2) as basic_value_score
        
    from nba_prospects_import
    where final_rank is not null 
      and final_gen_probability is not null
      and final_rank > 5  
),

-- step 2 : additition of bonus multipliers to create adjusted value score
enhanced_value as (
    select *,
        -- youth bonus (- 20yo)
        case when age < 20 then 1.25 else 1.0 end as youth_bonus,
        
        -- shooting bonus  (35%+ = very important in NBA)
        case when three_pt_pct >= 0.35 then 1.20 else 1.0 end as shooting_bonus,
        
        -- efficiency bonus  (ts% > 58% =  offensive maturity)
        case when ts_pct > 0.58 then 1.15 else 1.0 end as efficiency_bonus,
        
        -- production bonus  (15+ ppg = good scorer)
        case when ppg >= 15 then 1.10 else 1.0 end as production_bonus,
        
        -- old malus (22yo+ = limited ceiling)
        case when age >= 22 then 0.85 else 1.0 end as age_penalty
        
    from base_value
),

-- étape 3: steal score calculation
steal_calculation as (
    select *,

        round(
            basic_value_score * 
            youth_bonus * 
            shooting_bonus * 
            efficiency_bonus * 
            production_bonus * 
            age_penalty, 
            2
        ) as adjusted_steal_score,
        
        -- steal percentile ranked 
        percent_rank() over (order by 
            basic_value_score * youth_bonus * shooting_bonus * 
            efficiency_bonus * production_bonus * age_penalty
        ) as steal_percentile
        
    from enhanced_value
),

-- step 4 : steals classification
steal_classification as (
    select *,
        case 
            when adjusted_steal_score > 8 and final_rank > 15 
            then 'mega steal'
            
            when adjusted_steal_score > 5 and final_rank > 12 
            then 'excellent steal'
            
            when adjusted_steal_score > 3.5 and final_rank > 10 
            then 'good steal'
            
            when adjusted_steal_score > 2.5 
            then 'decent value'
            
            when adjusted_steal_score < 1.5 and final_rank <= 15 
            then 'potential reach'
            
            else 'fair value'
        end as steal_category,
        
   
        concat(
            case when youth_bonus > 1 then 'young + ' else '' end,
            case when shooting_bonus > 1 then 'shooter + ' else '' end,
            case when efficiency_bonus > 1 then 'efficient + ' else '' end,
            case when production_bonus > 1 then 'producer + ' else '' end,
            case when age_penalty < 1 then 'age_concern' else '' end
        ) as value_drivers,
        
        -- steals final ranking
        row_number() over (order by adjusted_steal_score desc) as steal_rank
        
    from steal_calculation
)

-- final results : top steals potential
select 
    steal_rank,
    name,
    position,
    final_rank,
    round(age, 1) as age,
    round(final_gen_probability, 3) as ai_potential,
    round(ppg, 1) as college_ppg,
    round(three_pt_pct, 3) as shooting_pct,
    basic_value_score,
    adjusted_steal_score,
    round(steal_percentile, 2) as percentile,
    steal_category,
    value_drivers
    
from steal_classification
where steal_category not in ('fair value', 'potential reach')  
order by adjusted_steal_score desc
limit 20;
