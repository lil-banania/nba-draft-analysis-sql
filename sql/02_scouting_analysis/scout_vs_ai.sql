with scout_conversion as (
    select 
        name, position, final_rank, scout_grade, final_gen_probability, ppg,
        
        -- simple conversion from grade to numeric values
        case scout_grade
            when 'A+' then 4.0 when 'A' then 3.5 when 'A-' then 3.0
            when 'B+' then 2.5 when 'B' then 2.0 when 'B-' then 1.5
            when 'C+' then 1.0 when 'C' then 0.5
            else 0.0
        end as scout_score,
        
        -- scale AI score
        final_gen_probability * 4 as ai_score
        
    from nba_prospects_import
    where scout_grade is not null and  final_gen_probability is not null
),
disagreement_analysis as (
    select *,
        -- score difference calculus
        abs(ai_score - scout_score) as disagreement_gap,
        
        -- optimism vs
        case 
            when ai_score > scout_score + 0.5 then 'AI more optimistic'
            when scout_score > ai_score + 0.5 then 'Scouts more optimistic'
            else 'Accord relatif'
        end as who_more_optimistic,
        
        -- Ranking des désaccords
        ROW_NUMBER() OVER (order by ABS(ai_score - scout_score) desc) as conflict_rank
    from scout_conversion
)
select 
    name, position, final_rank,
    scout_grade,
    ROUND(final_gen_probability, 3) as ai_potential,
    ROUND(disagreement_gap, 2) as disagreement,
    who_more_optimistic,
    
    -- Classification simple
    case 
        WHEN conflict_rank <= 5 then 'Top 5 conflicts'
        WHEN disagreement_gap > 1.0 then 'Strong disagreement'
        WHEN disagreement_gap > 0.5 then 'Average disagreement'
        ELSE '✅ Consensus'
    END as conflict_level
    
FROM disagreement_analysis
ORDER BY disagreement_gap DESC
LIMIT 15;
