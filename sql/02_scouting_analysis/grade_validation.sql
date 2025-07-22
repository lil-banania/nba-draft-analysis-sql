
-- step 1 : average performances by grades
with grade_performance as (
    select 
        scout_grade,
        count(*) as prospect_count,
        
      
        round(avg(ppg), 1) as avg_ppg,
        round(avg(COALESCE(three_pt_pct, 0)), 3) as avg_3pt,
        round(avg(ts_pct), 3) as avg_efficiency,
        round(avg(final_gen_probability), 3) as avg_ai_potential,
        round(avg(final_rank), 1) as avg_draft_position,
        
        -- Grade logic
        case scout_grade
            when 'A+' then 1 when 'A' then 2 when 'A-' then 3
            when 'B+' then 4 when 'B' then 5 when 'B-' then 6
            when 'C+' then 7 when 'C' then 8 when 'C-' then 9
            else 10
        end as grade_order
        
    from nba_prospects_2025
    where scout_grade is not null
    group by scout_grade
),

-- step 2 : logical verification of performance progression
grade_progression as (
    select *,
       
        lag(avg_ppg) over (order by grade_order) as prev_grade_ppg,
        lag(avg_ai_potential) over (order by grade_order) as prev_grade_potential,
        
        case
            when avg_ppg < LAG(avg_ppg) over (order by grade_order) then 'Logical'
            when lag(avg_ppg) OVER (order by grade_order) is null then 'Top Grade'
            else 'Inversion'
        end as ppg_progression,
        
        case 
            when avg_ai_potential < lag(avg_ai_potential) over (order by grade_order) then 'Logical'
            when LAG(avg_ai_potential) OVER (order by grade_order) is null then 'Top Grade'
            else 'Inversion'
        end as potential_progression
        
    from grade_performance
)

-- Results
select 
    scout_grade,
    prospect_count,
    avg_ppg,
    avg_3pt,
    avg_ai_potential,
    avg_draft_position,
    ppg_progression,
    potential_progression,
    

    case 
        when ppg_progression = 'Inversion' or potential_progression = 'Inversion' 
        then ''
        when avg_ppg > 15 and avg_ai_potential > 0.7 
        then 'Premium Grade'
        when avg_ppg < 8 and avg_ai_potential < 0.4 
        then 'Low grade'
        else 'Logical grade'
    end as grade_assessment
    
from grade_progression
order by grade_order;
