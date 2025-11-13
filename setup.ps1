# Exotic Animal Database - Setup Script for Windows

Write-Host "🦁 Exotic Animal Database - Setup Script" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""

# Check if Node.js is installed
Write-Host "Checking for Node.js..." -ForegroundColor Yellow
$nodeVersion = node --version 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Node.js is installed: $nodeVersion" -ForegroundColor Green
} else {
    Write-Host "✗ Node.js is not installed!" -ForegroundColor Red
    Write-Host "Please install Node.js from https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

# Check if PostgreSQL is installed
Write-Host "Checking for PostgreSQL..." -ForegroundColor Yellow
$psqlVersion = psql --version 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ PostgreSQL is installed: $psqlVersion" -ForegroundColor Green
} else {
    Write-Host "✗ PostgreSQL is not installed!" -ForegroundColor Red
    Write-Host "Please install PostgreSQL from https://www.postgresql.org/download/" -ForegroundColor Yellow
    exit 1
}

# Install Node.js dependencies
Write-Host ""
Write-Host "Installing Node.js dependencies..." -ForegroundColor Yellow
npm install
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Dependencies installed successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to install dependencies" -ForegroundColor Red
    exit 1
}

# Check if .env exists
Write-Host ""
if (-not (Test-Path ".env")) {
    Write-Host "Creating .env file from template..." -ForegroundColor Yellow
    Copy-Item ".env.example" ".env"
    Write-Host "✓ .env file created" -ForegroundColor Green
    Write-Host "⚠ Please edit .env file and update your PostgreSQL password!" -ForegroundColor Yellow
} else {
    Write-Host "✓ .env file already exists" -ForegroundColor Green
}

# Ask if user wants to create the database
Write-Host ""
$createDB = Read-Host "Do you want to create the PostgreSQL database now? (y/n)"
if ($createDB -eq "y" -or $createDB -eq "Y") {
    Write-Host ""
    $dbUser = Read-Host "Enter PostgreSQL username (default: postgres)"
    if ([string]::IsNullOrWhiteSpace($dbUser)) {
        $dbUser = "postgres"
    }
    
    Write-Host "Creating database 'exoticanimaldb'..." -ForegroundColor Yellow
    $createDbCommand = "CREATE DATABASE exoticanimaldb;"
    $createDbCommand | psql -U $dbUser -d postgres 2>$null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Database created successfully" -ForegroundColor Green
        
        Write-Host "Loading database schema..." -ForegroundColor Yellow
        psql -U $dbUser -d exoticanimaldb -f "schema_postgresql.sql"
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Schema loaded successfully with sample data" -ForegroundColor Green
        } else {
            Write-Host "⚠ There was an issue loading the schema" -ForegroundColor Yellow
            Write-Host "You can manually load it later using:" -ForegroundColor Yellow
            Write-Host "psql -U $dbUser -d exoticanimaldb -f schema_postgresql.sql" -ForegroundColor Cyan
        }
    } else {
        Write-Host "⚠ Database might already exist or there was an error" -ForegroundColor Yellow
        Write-Host "Attempting to load schema anyway..." -ForegroundColor Yellow
        psql -U $dbUser -d exoticanimaldb -f "schema_postgresql.sql"
    }
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Green
Write-Host "Setup Complete! 🎉" -ForegroundColor Green
Write-Host "=========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Edit .env file with your PostgreSQL password" -ForegroundColor White
Write-Host "2. Run: npm start" -ForegroundColor Cyan
Write-Host "3. Open: http://localhost:3000" -ForegroundColor Cyan
Write-Host ""
Write-Host "For development mode with auto-restart:" -ForegroundColor Yellow
Write-Host "Run: npm run dev" -ForegroundColor Cyan
Write-Host ""
