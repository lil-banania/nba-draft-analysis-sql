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
    from complete_nba_draft_rankings
    where position is not null
    group by position
)
