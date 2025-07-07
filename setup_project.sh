# setup_project.sh
#!/bin/bash

echo "🏀 Setting up NBA Draft Analysis SQL Project..."

# 1. Create database
echo "📊 Creating database..."
createdb nba_draft_analysis
psql nba_draft_analysis -c "CREATE USER nba_analyst WITH PASSWORD 'nba2025';"
psql nba_draft_analysis -c "GRANT ALL PRIVILEGES ON DATABASE nba_draft_analysis TO nba_analyst;"

# 2. Run setup scripts
echo "🗃️ Setting up schema and tables..."
psql nba_draft_analysis -f sql/01_setup/create_schema.sql
psql nba_draft_analysis -f sql/01_setup/create_tables.sql

# 3. Load your data (adjust path)
echo "📈 Loading draft data..."
# psql nba_draft_analysis -f sql/01_setup/load_data.sql

echo "✅ Setup complete! Your NBA Draft Analysis environment is ready."
echo "🔗 Connect to: postgresql://localhost:5432/nba_draft_analysis"
echo "👤 User: nba_analyst | Password: nba2025"
