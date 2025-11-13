# Database Verification Demo Script
# Run these commands to prove data is stored in PostgreSQL

Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host "EXOTIC ANIMAL DATABASE - VERIFICATION DEMO" -ForegroundColor Green
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host ""

# 1. Show database exists
Write-Host "1. Verifying database exists..." -ForegroundColor Yellow
& "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -c "SELECT datname FROM pg_database WHERE datname = 'exoticanimaldb';"
Write-Host ""

# 2. Show all tables
Write-Host "2. Listing all tables in the database..." -ForegroundColor Yellow
& "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d exoticanimaldb -c "\dt"
Write-Host ""

# 3. Show record counts
Write-Host "3. Record counts in each table..." -ForegroundColor Yellow
& "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d exoticanimaldb -c "SELECT 'Animals' as Table_Name, COUNT(*) as Total_Records FROM Animals UNION ALL SELECT 'Species', COUNT(*) FROM Species UNION ALL SELECT 'Facilities', COUNT(*) FROM Facilities UNION ALL SELECT 'Keepers', COUNT(*) FROM Keepers UNION ALL SELECT 'Medical Records', COUNT(*) FROM MedicalRecords UNION ALL SELECT 'Breeding Records', COUNT(*) FROM BreedingRecords;"
Write-Host ""

# 4. Show sample data from Animals table
Write-Host "4. Sample data from Animals table..." -ForegroundColor Yellow
& "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d exoticanimaldb -c "SELECT animal_id, animal_name, gender, health_status, weight_kg, microchip_id FROM Animals LIMIT 5;"
Write-Host ""

# 5. Show sample data from Species table
Write-Host "5. Sample data from Species table..." -ForegroundColor Yellow
& "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d exoticanimaldb -c "SELECT species_id, species_name, scientific_name, conservation_status FROM Species;"
Write-Host ""

# 6. Show a JOIN query (proves relational database)
Write-Host "6. JOIN query showing animals with their species (proves relational data)..." -ForegroundColor Yellow
& "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d exoticanimaldb -c "SELECT a.animal_name, s.species_name, s.scientific_name, f.facility_name FROM Animals a JOIN Species s ON a.species_id = s.species_id JOIN Facilities f ON a.facility_id = f.facility_id LIMIT 5;"
Write-Host ""

# 7. Show database functions work
Write-Host "7. Testing custom database functions..." -ForegroundColor Yellow
& "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d exoticanimaldb -c "SELECT animal_name, getAnimalAgeYears(animal_id) as age_years, totalMedicalCost(animal_id) as total_medical_cost, healthRiskScore(animal_id) as risk_score FROM Animals LIMIT 3;"
Write-Host ""

Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host "VERIFICATION COMPLETE!" -ForegroundColor Green
Write-Host "All data is stored in PostgreSQL database 'exoticanimaldb'" -ForegroundColor Green
Write-Host "=" * 60 -ForegroundColor Cyan
