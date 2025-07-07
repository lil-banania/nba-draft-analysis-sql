CREATE INDEX IF NOT EXISTS idx_prospects_rank ON nba_prospects_import(final_rank);
CREATE INDEX IF NOT EXISTS idx_prospects_position ON nba_prospects_import(position);
CREATE INDEX IF NOT EXISTS idx_prospects_potential ON nba_prospects_import(final_gen_probability DESC);
CREATE INDEX IF NOT EXISTS idx_prospects_grade ON nba_prospects_import(scout_grade);

-- indexes for analyzes
CREATE INDEX IF NOT EXISTS idx_prospects_pos_rank ON nba_prospects_import(position, final_rank);
CREATE INDEX IF NOT EXISTS idx_prospects_age_potential ON nba_prospects_import(age, final_gen_probability DESC);
CREATE INDEX IF NOT EXISTS idx_prospects_stats ON nba_prospects_import(ppg, rpg, apg) WHERE ppg IS NOT NULL;


ANALYZE nba_prospects_import;
		   
