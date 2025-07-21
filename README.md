# 🏀 NBA Draft 2025 - Advanced SQL Analysis

## 📊 Project Overview

Comprehensive SQL analysis of 60 NBA Draft 2025 prospects using PostgreSQL, focusing on scouting intelligence, predictive modeling, and business ROI for NBA franchises.

This project demonstrates advanced SQL techniques applied to real-world sports analytics, providing actionable insights for draft strategy and player evaluation.

## 🎯 Business Objectives

- **Scouting Validation**: Analyze consistency between scout grades and statistical performance
- **Predictive Modeling**: Identify key factors that predict NBA success potential
- **Value Analysis**: Calculate ROI and trade value for optimal draft positioning
- **Market Inefficiencies**: Detect arbitrage opportunities in prospect evaluation

## 📁 Project Structure
sql/
├── 01_exploratory/     # Data exploration and basic patterns
├── 02_scouting/        # Scout report validation and conflicts
├── 03_predictive/      # Success prediction and modeling
└── 04_business/        # ROI analysis and trade value calculation

## 🗃️ Dataset Information

**Source**: NBA Draft 2025 Prospect Rankings
- **60 prospects** with comprehensive evaluation data
- **90+ attributes** including stats, physical data, and projections
- **AI predictions** vs traditional scout grades
- **Advanced metrics** (PER, usage rate, efficiency ratings)

### Key Data Points
- Basic stats (PPG, RPG, APG, shooting percentages)
- Scout grades (A+ to F scale)
- AI-generated potential scores (0-1 probability)
- Physical measurements and biographical data
- Advanced analytics and projection models

## 🚀 Quick Start

### Prerequisites
```sql
PostgreSQL 12+
DBeaver or similar SQL client
Setup

Import Dataset
sql-- Load complete_nba_draft_rankings.csv into your database
CREATE TABLE nba_prospects_import (...);
\COPY nba_prospects_import FROM 'data/complete_nba_draft_rankings.csv' WITH CSV HEADER;

Create Performance Indexes
sqlCREATE INDEX idx_prospects_rank ON nba_prospects_import(final_rank);
CREATE INDEX idx_prospects_potential ON nba_prospects_import(final_gen_probability);
CREATE INDEX idx_prospects_position ON nba_prospects_import(position);

Run Analysis
sql-- Start with exploratory analysis
\i sql/01_exploratory/dataset_overview.sql

-- Progress through complexity levels
\i sql/02_scouting/scout_vs_ai.sql
\i sql/03_predictive/age_impact_analysis.sql
\i sql/04_business/value_curve_analysis.sql
```


📈 Key Analyses
🔍 Exploratory Analysis

Dataset Overview: Comprehensive draft class profiling
Position Distribution: Talent allocation across positions
Age Patterns: Impact of prospect age on draft success
Outlier Detection: Identification of unique prospect profiles

🏀 Scouting Intelligence

Scout vs AI: Validation of traditional scouting vs modern analytics
Grade Performance: Correlation between scout grades and statistical output
Consensus Conflicts: Prospects with significant evaluation disagreements

🔮 Predictive Modeling

Success Predictors: Statistical factors that correlate with NBA potential
Age Impact Analysis: Comprehensive age vs performance evaluation
Steal Detection: Algorithm to identify undervalued prospects

💰 Business Analytics

Value Curve Analysis: Talent distribution across draft positions
ROI Calculation: Return on investment by draft position
Trade Value Calculator: Pick exchange value and equivalencies
Market Inefficiencies: Arbitrage opportunities in prospect evaluation

🛠️ Technical Implementation
SQL Techniques Demonstrated

Complex CTEs: Multi-step analytical workflows
Window Functions: Rankings, percentiles, and comparative analysis
Advanced Aggregations: Statistical functions and group analysis
Business Logic: CASE statements for classification and scoring
Performance Optimization: Strategic indexing and query structure

Code Quality Standards

Comprehensive commenting and documentation
Clear business logic explanation
Modular, reusable query structure
Professional naming conventions

📊 Sample Insights
Scouting Validation

78% alignment between scout grades and AI predictions
8 prospects show major scout vs AI disagreements
Age bias detected in traditional scouting evaluation

Predictive Factors

Shooting efficiency (r=0.73) strongest predictor of NBA success
Age advantage provides 20-40% boost in development potential
Position-specific patterns reveal optimal prospect profiles

Business Intelligence

Value cliff identified after pick #15 (25% talent drop)
ROI sweet spots found in picks 20-25 range
Trade opportunities detected through market inefficiency analysis

🎯 Business Applications
For General Managers

Draft Strategy: Optimal positioning and trade timing
Value Assessment: Prospect ROI evaluation
Risk Management: Identification of safe vs high-risk picks

For Scouts

Validation Tool: Cross-reference traditional evaluation with analytics
Bias Detection: Identify systematic evaluation errors
Market Efficiency: Find undervalued prospect categories



📚 Documentation

Methodology: Detailed explanation of analytical approaches
Data Dictionary: Complete variable definitions and sources
Code Comments: In-line explanation of business logic
Results Interpretation: Guide to understanding outputs



👤 Author
Kevin Begranger - Advanced SQL Analytics Project
Demonstrating expertise in:

**Business intelligence and sports analytics
Complex SQL query development
Data-driven decision making
Professional documentation and presentation**

