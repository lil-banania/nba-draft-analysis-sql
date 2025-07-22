-- age impact calculation
with age_groups as (
    select 
        name,
        final_rank,
        age,
        final_gen_probability,
        case 
            when age < 19.5 then 'very young'
            when age < 20.5 then 'young' 
            when age < 21.5 then 'average'
            else 'old'
        end as age_category
    from nba_prospects_2025
    where age is not null
)
select 
    age_category,
    count(*) as prospects,
    round(avg(age), 1) as avg_age,
    round(avg(final_gen_probability), 3) as avg_potential,
    round(avg(final_rank), 1) as avg_draft_position,
    string_agg(name, ', ' order by final_gen_probability desc limit 3) as top_examples
from age_groups
group by age_category
order by avg_potential desc;
