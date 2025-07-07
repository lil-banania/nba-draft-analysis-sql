with value_calculation as (
    select 
        name, position, final_rank, age, final_gen_probability, ppg, three_pt_pct,
        
        -- Value score calculation
        round((final_gen_probability * 100 / NULLIF(final_rank, 0)), 2) as basic_value,
        
        -- additional bonuses calculation for Value Score ponderation
         case when age < 20 then 1.2 else 1.0 end as youth_bonus,
        case when three_pt_pct > 0.35 then 1.15 else 1.0 end as shooting_bonus,
        case when ppg > 15 then 1.1 else 1.0 end as scoring_bonus
        
    from nba_prospects_import
    where final_rank is not null and final_gen_probability is not null
),
adjusted_value AS (
    select *,
        -- adjusted Value Score
        round(basic_value * youth_bonus * shooting_bonus * scoring_bonus, 2) as adjusted_value_score,
        
        percent_rank() OVER (order by basic_value * youth_bonus * shooting_bonus * scoring_bonus) as value_percentile
        
    from value_calculation
)
select 
    name, position, final_rank, 
    round(age, 1) as age,
    round(final_gen_probability, 3) as potential,
    adjusted_value_score,
    round(value_percentile, 2) as value_percentile,
    
    -- Steals classification
    case 
        when adjusted_value_score > 8 and final_rank > 15 then 'Potential Mega Steal'
        when adjusted_value_score > 5 and final_rank > 10 then 'Good Value Pick'
        when adjusted_value_score > 3 then '➡Fair Value'
        when adjusted_value_score < 2 and final_rank <= 15 then 'Potential Overpay'
        else 'Standard Pick'
    end as value_assessment,
    
    CONCAT(
        case when youth_bonus > 1 then 'Young + ' else '' end,
        case when shooting_bonus > 1 then 'Shooter + ' else '' end,
        case when scoring_bonus > 1 then 'Scorer' else '' end
    ) as value_drivers
    
from adjusted_value
order by  adjusted_value_score desc;
