-- ==========================================
-- GRADE VALIDATION ANALYSIS
-- ==========================================
-- 🎯 OBJECTIF: Vérifier la cohérence des grades scouts avec les performances
-- ❓ QUESTION: Les grades A sont-ils vraiment meilleurs que les grades B ?
-- 🔧 MÉTHODE: Progression des moyennes + détection anomalies
-- ==========================================

-- ÉTAPE 1: Performance moyenne par grade
WITH grade_performance AS (
    SELECT 
        scout_grade,
        COUNT(*) as prospect_count,
        
        -- Moyennes des métriques clés
        ROUND(AVG(ppg), 1) as avg_ppg,
        ROUND(AVG(COALESCE(three_pt_pct, 0)), 3) as avg_3pt,
        ROUND(AVG(ts_pct), 3) as avg_efficiency,
        ROUND(AVG(final_gen_probability), 3) as avg_ai_potential,
        ROUND(AVG(final_rank), 1) as avg_draft_position,
        
        -- Ordre logique des grades
        CASE scout_grade
            WHEN 'A+' THEN 1 WHEN 'A' THEN 2 WHEN 'A-' THEN 3
            WHEN 'B+' THEN 4 WHEN 'B' THEN 5 WHEN 'B-' THEN 6
            WHEN 'C+' THEN 7 WHEN 'C' THEN 8 WHEN 'C-' THEN 9
            ELSE 10
        END as grade_order
        
    FROM nba_prospects_import
    WHERE scout_grade IS NOT NULL
    GROUP BY scout_grade
),

-- ÉTAPE 2: Vérification de la progression logique
grade_progression AS (
    SELECT *,
        -- Performance de la grade précédente
        LAG(avg_ppg) OVER (ORDER BY grade_order) as prev_grade_ppg,
        LAG(avg_ai_potential) OVER (ORDER BY grade_order) as prev_grade_potential,
        
        -- Y a-t-il "inversion" ? (grade inférieur > grade supérieur)
        CASE 
            WHEN avg_ppg < LAG(avg_ppg) OVER (ORDER BY grade_order) THEN '✅ Logique'
            WHEN LAG(avg_ppg) OVER (ORDER BY grade_order) IS NULL THEN '👑 Top Grade'
            ELSE '❌ Inversion!'
        END as ppg_progression,
        
        CASE 
            WHEN avg_ai_potential < LAG(avg_ai_potential) OVER (ORDER BY grade_order) THEN '✅ Logique'
            WHEN LAG(avg_ai_potential) OVER (ORDER BY grade_order) IS NULL THEN '👑 Top Grade'
            ELSE '❌ Inversion!'
        END as potential_progression
        
    FROM grade_performance
)

-- RÉSULTATS: Validation des grades
SELECT 
    scout_grade,
    prospect_count,
    avg_ppg,
    avg_3pt,
    avg_ai_potential,
    avg_draft_position,
    ppg_progression,
    potential_progression,
    
    -- Assessment global du grade
    CASE 
        WHEN ppg_progression = '❌ Inversion!' OR potential_progression = '❌ Inversion!' 
        THEN '⚠️ Grade Suspect'
        WHEN avg_ppg > 15 AND avg_ai_potential > 0.7 
        THEN '⭐ Grade Premium'
        WHEN avg_ppg < 8 AND avg_ai_potential < 0.4 
        THEN '📉 Grade Faible'
        ELSE '✅ Grade Cohérent'
    END as grade_assessment
    
FROM grade_progression
ORDER BY grade_order;
