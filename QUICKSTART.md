# 🚀 Quick Start Guide

## Prerequisites Installation

### 1. Install PostgreSQL
```powershell
# Using winget (Windows 10+)
winget install PostgreSQL.PostgreSQL

# Or download installer from:
# https://www.postgresql.org/download/windows/
```

### 2. Install Node.js
```powershell
# Using winget
winget install OpenJS.NodeJS

# Or download from:
# https://nodejs.org/
```

## Setup Steps

### Option 1: Automated Setup (Recommended)
```powershell
# Run the setup script
.\setup.ps1
```

### Option 2: Manual Setup

1. **Install Dependencies**
```powershell
npm install
```

2. **Create Environment File**
```powershell
cp .env.example .env
```
Edit `.env` and set your PostgreSQL password

3. **Create Database**
```powershell
# Connect to PostgreSQL
psql -U postgres

# Create database
CREATE DATABASE exoticanimaldb;
\q
```

4. **Load Schema**
```powershell
psql -U postgres -d exoticanimaldb -f schema_postgresql.sql
```

5. **Start Server**
```powershell
npm start
```

6. **Open Browser**
Navigate to: http://localhost:3000

## Default Credentials

- **Database Name:** exoticanimaldb
- **Database User:** postgres
- **Database Password:** (your PostgreSQL password)
- **Server Port:** 3000

## Testing the Application

Once the server is running:

1. **Dashboard** - View statistics of animals, species, facilities
2. **Animals Tab** - View all animals, click "Details" for more info
3. **Add Animal** - Click "+ Add Animal" button
4. **Medical Records** - Add and track medical visits
5. **Other Tabs** - Explore species, facilities, keepers, and breeding records

## Sample Data Included

The database comes with:
- 7 Species (Bengal Tiger, African Elephant, Snow Leopard, etc.)
- 5 Facilities (Zoos, Sanctuaries, Aquariums)
- 7 Keepers
- 8 Animals
- Medical and breeding records

## Troubleshooting

### PostgreSQL not starting
```powershell
# Start PostgreSQL service
net start postgresql-x64-14
```

### Port 3000 already in use
Edit `.env` and change PORT to another value:
```
PORT=8080
```

### Database connection failed
Check your `.env` file:
- Correct username
- Correct password
- Database name matches
- PostgreSQL service is running

## Development Mode

For development with auto-restart:
```powershell
npm run dev
```

## Need Help?

Check the full README.md for detailed documentation!
