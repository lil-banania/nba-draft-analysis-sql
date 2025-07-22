-- Scout VS AI predictions

with scout_analysis as (
    select 
        scout_grade,
        count(*) as prospects,
        round(avg(ppg), 1) as avg_production,
        round(avg(final_gen_probability), 3) as avg_ai_potential,
        round(avg(final_rank), 1) as avg_draft_pos,
        
        -- Conversion to numeric scores
        case scout_grade
            when 'A+' then 4.3 when 'A' then 4.0 when 'A-' then 3.7
            when 'B+' then 3.3 when 'B' then 3.0 when 'B-' then 2.7
            when 'C+' then 2.3 when 'C' then 2.0 when 'C-' then 1.7
            ELSE 2.0
        end as scout_numeric,
        
        avg(final_gen_probability) * 4 as ai_numeric
        
    from nba_prospects_2025
    where scout_grade is not null and final_gen_probability is not null
    group by scout_grade
)
select 
    scout_grade,
    prospects,
    avg_production,
    avg_ai_potential,
    avg_draft_pos,
    round(abs(ai_numeric - scout_numeric), 2) as disagreement,
    
    case 
        when ABS(ai_numeric - scout_numeric) < 0.3 then 'Agreed on players'
        when ABS(ai_numeric - scout_numeric) < 0.6 then 'Ligt disagreement'
        else 'Major disagreement'
    and as consensus_level
    
from scout_analysis
order by 
    case scout_grade
        when 'A+' then 1 when 'A' then 2 when 'A-' then 3
        when 'B+' then 4 when 'B' then 5 when 'B-' then 6
        when 'C+' then 7 when 'C' then 8 when 'C-' then 9
        ELSE 10
    end;
