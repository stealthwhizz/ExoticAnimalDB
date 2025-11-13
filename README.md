# 🦁 Exotic Animal Database Management System

A comprehensive, full-stack database management system for exotic animal facilities with PostgreSQL backend and modern web UI.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-13+-blue.svg)
![Node.js](https://img.shields.io/badge/Node.js-16+-green.svg)

## 📋 Features

### Database Features
- **Species Management**: Track different exotic species with conservation status, habitat, and diet information
- **Facility Management**: Manage multiple facilities (zoos, sanctuaries, aquariums, research centers)
- **Animal Tracking**: Complete animal records with health status, weight, and microchip IDs
- **Keeper Management**: Track animal keepers with specializations and certifications
- **Medical Records**: Comprehensive medical history with veterinarian visits and treatments
- **Breeding Programs**: Track breeding records and offspring
- **Advanced Functions**: Calculate animal age, total medical costs, and health risk scores
- **Stored Procedures**: Automated workflows for adding animals, assigning keepers, and recording medical visits
- **Triggers**: Enforce business rules and data integrity

### Web UI Features
- **Interactive Dashboard**: Real-time statistics and key metrics
- **Animal Management**: Add, view, and update animal records
- **Detailed Views**: View comprehensive animal details including health risk scores
- **Medical Records**: Track and add medical visits
- **Breeding Records**: Monitor breeding programs
- **Responsive Design**: Works on desktop, tablet, and mobile devices
- **Beautiful Interface**: Modern gradient design with intuitive navigation

## 🚀 Quick Start

### Prerequisites

1. **PostgreSQL** (version 13 or higher)
   - Download from: https://www.postgresql.org/download/
   - Or install via package manager:
     ```powershell
     # Windows (using Chocolatey)
     choco install postgresql

     # Or using winget
     winget install PostgreSQL.PostgreSQL
     ```

2. **Node.js** (version 16 or higher)
   - Download from: https://nodejs.org/
   - Or install via package manager:
     ```powershell
     # Windows (using Chocolatey)
     choco install nodejs

     # Or using winget
     winget install OpenJS.NodeJS
     ```

### Installation Steps

1. **Clone the Repository**
   ```powershell
   cd C:\Users\whizy\GitHub\ExoticAnimalDB
   ```

2. **Install Node.js Dependencies**
   ```powershell
   npm install
   ```

3. **Set Up PostgreSQL Database**

   a. Start PostgreSQL service (if not already running):
   ```powershell
   # Start PostgreSQL service
   net start postgresql-x64-14  # Adjust version number as needed
   ```

   b. Create the database and schema:
   ```powershell
   # Option 1: Using psql command line
   psql -U postgres -c "CREATE DATABASE exoticanimaldb;"
   psql -U postgres -d exoticanimaldb -f schema_postgresql.sql

   # Option 2: Using pgAdmin
   # - Open pgAdmin
   # - Create new database named 'exoticanimaldb'
   # - Open Query Tool and run schema_postgresql.sql
   ```

4. **Configure Environment Variables**
   ```powershell
   # Copy the example env file
   cp .env.example .env

   # Edit .env and update with your PostgreSQL credentials
   # DB_USER=postgres
   # DB_PASSWORD=your_password_here
   # DB_NAME=exoticanimaldb
   # DB_HOST=localhost
   # DB_PORT=5432
   ```

5. **Start the Server**
   ```powershell
   npm start
   ```

6. **Access the Application**
   - Open your browser and navigate to: http://localhost:3000
   - The web UI should load with the dashboard

## 📁 Project Structure

```
ExoticAnimalDB/
├── server.js                    # Express server with REST API
├── schema_postgresql.sql        # PostgreSQL database schema
├── ExoticAnimalDB.sql          # Original MySQL schema
├── package.json                # Node.js dependencies
├── .env.example                # Environment variables template
├── .gitignore                  # Git ignore file
├── README.md                   # This file
├── LICENSE                     # License file
└── public/                     # Frontend files
    ├── index.html              # Main HTML page
    ├── styles.css              # CSS styles
    └── app.js                  # Frontend JavaScript
```

## 🔌 API Endpoints

### Dashboard
- `GET /api/dashboard/stats` - Get dashboard statistics

### Animals
- `GET /api/animals` - Get all animals
- `GET /api/animals/:id` - Get animal by ID with computed metrics
- `POST /api/animals` - Create new animal (uses stored procedure)
- `PUT /api/animals/:id` - Update animal
- `GET /api/animals/:id/medical` - Get medical records for an animal
- `GET /api/animals/:id/care` - Get care assignments for an animal

### Species
- `GET /api/species` - Get all species
- `GET /api/species/:id` - Get species by ID
- `POST /api/species` - Create new species

### Facilities
- `GET /api/facilities` - Get all facilities
- `GET /api/facilities/:id` - Get facility by ID
- `POST /api/facilities` - Create new facility

### Keepers
- `GET /api/keepers` - Get all keepers with facility info
- `POST /api/keepers` - Create new keeper

### Medical Records
- `POST /api/medical` - Create medical record (uses stored procedure)

### Animal Care
- `POST /api/care/assign` - Assign keeper to animal (uses stored procedure)

### Breeding Records
- `GET /api/breeding` - Get all breeding records
- `POST /api/breeding` - Create breeding record

### Views
- `GET /api/views/active-animals` - Get active animals view
- `GET /api/views/keeper-assignments` - Get keeper assignments view

## 🗄️ Database Schema

### Main Tables
1. **Species** - Species information and conservation status
2. **Facilities** - Wildlife facilities (zoos, sanctuaries, etc.)
3. **Keepers** - Animal care staff
4. **Animals** - Individual animal records
5. **AnimalCare** - Keeper assignments
6. **MedicalRecords** - Medical history
7. **BreedingRecords** - Breeding program data

### Functions
- `getAnimalAgeYears(animal_id)` - Calculate animal's age
- `totalMedicalCost(animal_id)` - Calculate total medical expenses
- `healthRiskScore(animal_id)` - Calculate health risk score (1-8)

### Stored Procedures
- `addAnimal(...)` - Add new animal with validation
- `assignPrimaryKeeper(...)` - Assign keeper to animal
- `recordMedicalVisit(...)` - Record medical visit with automatic health status update

### Views
- `ActiveAnimalsView` - Active animals with species and facility info
- `KeeperAssignmentsView` - Current keeper assignments

## 🎨 UI Features

### Dashboard
- Real-time statistics cards
- Color-coded health warnings
- Quick access to all modules

### Animals Tab
- Searchable animal list
- Add new animals with form validation
- View detailed animal information in modal
- Health status badges

### Medical Records
- Add medical visits
- Track veterinarian information
- Record diagnoses, treatments, and medications

### Breeding Records
- Track breeding pairs
- Monitor offspring
- Success/failure indicators

## 🔧 Configuration

### Database Connection
Edit `.env` file to configure database connection:

```env
DB_USER=postgres
DB_HOST=localhost
DB_NAME=exoticanimaldb
DB_PASSWORD=your_password
DB_PORT=5432
PORT=3000
```

### Server Port
The default server port is 3000. Change it in `.env`:
```env
PORT=8080
```

## 🧪 Testing

### Test Database Functions
After setting up the database, you can test the functions:

```sql
-- Test age calculation
SELECT animal_name, getAnimalAgeYears(animal_id) AS age_years
FROM Animals;

-- Test medical cost calculation
SELECT animal_name, totalMedicalCost(animal_id) AS total_cost
FROM Animals;

-- Test health risk score
SELECT animal_name, healthRiskScore(animal_id) AS risk_score
FROM Animals
ORDER BY risk_score DESC;
```

### Test API Endpoints
Use curl or Postman to test API endpoints:

```powershell
# Get all animals
curl http://localhost:3000/api/animals

# Get dashboard stats
curl http://localhost:3000/api/dashboard/stats

# Get specific animal
curl http://localhost:3000/api/animals/1
```

## 🛠️ Development

### Run in Development Mode
Uses nodemon for automatic server restart on file changes:

```powershell
npm run dev
```

### Database Changes
After modifying the schema, reload it:

```powershell
psql -U postgres -d exoticanimaldb -f schema_postgresql.sql
```

## 📊 Sample Data

The database comes pre-loaded with sample data:
- 7 exotic species (Bengal Tiger, African Elephant, Snow Leopard, etc.)
- 5 facilities across India
- 7 animal keepers
- 8 animals with complete records
- Medical records and breeding data

## 🔒 Security Notes

- Never commit `.env` file with real credentials
- Use environment variables for sensitive data
- Implement proper authentication for production use
- Sanitize user inputs to prevent SQL injection
- Use HTTPS in production

## 🚀 Production Deployment

For production deployment:

1. Use a production PostgreSQL instance
2. Set strong database passwords
3. Enable SSL/TLS for database connections
4. Add authentication middleware (JWT, OAuth, etc.)
5. Use a reverse proxy (nginx, Apache)
6. Enable CORS only for trusted domains
7. Set up proper logging and monitoring

## 🐛 Troubleshooting

### PostgreSQL Connection Issues
```powershell
# Check if PostgreSQL is running
Get-Service postgresql*

# Start PostgreSQL service
net start postgresql-x64-14
```

### Port Already in Use
If port 3000 is already in use, change the port in `.env`:
```env
PORT=8080
```

### Database Permission Issues
Ensure your PostgreSQL user has proper permissions:
```sql
GRANT ALL PRIVILEGES ON DATABASE exoticanimaldb TO postgres;
```

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📧 Support

For issues and questions, please open an issue on GitHub.

## 🎉 Acknowledgments

- Original MySQL schema design for Database Systems lab
- Converted and enhanced for PostgreSQL with modern web UI
- Built with Express.js, PostgreSQL, and vanilla JavaScript

---

Made with ❤️ for wildlife conservation and management
