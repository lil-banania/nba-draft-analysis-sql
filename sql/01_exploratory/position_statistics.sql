-- View showing averages stats per position

create or replace view position_metrics as
with position_stats as (
    select 
        position,
        count(*) as prospect_count,
        avg(final_gen_probability) as avg_potential,
        stddev(final_gen_probability) as potential_variance,
        avg(ppg) as avg_scoring,
        avg(age) as avg_age,
        -- Grade distribution
        count(*) filter (where scout_grade in ('A+', 'A', 'A-')) as elite_grades,
        count(*) filter (where final_gen_probability > 0.7) as high_potential_count
    from nba_prospects_import
    where position is not null
    group by position
)
select *,
    round((elite_grades::NUMERIC / prospect_count * 100), 1) as elite_grade_pct,
    round((high_potential_count::NUMERIC / prospect_count * 100), 1) as high_potential_pct,
    -- Variation coeff
    round((potential_variance / NULLIF(avg_potential, 0)), 3) as potential_consistency
from position_stats;


select * from position_metrics 
order by avg_potential desc;
