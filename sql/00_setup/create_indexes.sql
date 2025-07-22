
-- performance indexes for nba draft analysis


-- essentials indexes 
create index idx_prospects_rank on nba_prospects_2025(final_rank);
create index idx_prospects_position on nba_prospects_2025(position);
create index idx_prospects_potential on nba_prospects_2025(final_gen_probability desc);
create index idx_prospects_age on nba_prospects_2025(age);
create index idx_prospects_grade on nba_prospects_2025(scout_grade);

-- main stats indexes 
create index idx_prospects_ppg on nba_prospects_2025(ppg desc);
create index idx_prospects_shooting on nba_prospects_2025(three_pt_pct desc);
create index idx_prospects_efficiency on nba_prospects_2025(ts_pct desc);

-- frequent queries indexes
create index idx_position_rank on nba_prospects_2025(position, final_rank);
create index idx_position_potential on nba_prospects_2025(position, final_gen_probability desc);
create index idx_age_potential on nba_prospects_2025(age, final_gen_probability desc);
create index idx_rank_potential on nba_prospects_2025(final_rank, final_gen_probability);

-- business queries 
create index idx_value_analysis on nba_prospects_2025(final_rank, final_gen_probability) 
where final_rank is not null and final_gen_probability is not null;

-- partial stats indexes
create index idx_complete_stats on nba_prospects_2025(ppg, rpg, apg) 
where ppg is not null and rpg is not null and apg is not null;

-- final optimization
analyze nba_prospects_2025;
