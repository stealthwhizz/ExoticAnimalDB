const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('public'));

// PostgreSQL connection pool
const pool = new Pool({
  user: process.env.DB_USER || 'postgres',
  host: process.env.DB_HOST || 'localhost',
  database: process.env.DB_NAME || 'exoticanimaldb',
  password: process.env.DB_PASSWORD || 'postgres',
  port: process.env.DB_PORT || 5432,
});

// Test database connection
pool.query('SELECT NOW()', (err, res) => {
  if (err) {
    console.error('Error connecting to the database:', err);
  } else {
    console.log('Database connected successfully at:', res.rows[0].now);
  }
});

// ============================================
// SPECIES ROUTES
// ============================================

// Get all species
app.get('/api/species', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM Species ORDER BY species_id');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch species' });
  }
});

// Get species by ID
app.get('/api/species/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('SELECT * FROM Species WHERE species_id = $1', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Species not found' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch species' });
  }
});

// Create new species
app.post('/api/species', async (req, res) => {
  try {
    const { species_name, scientific_name, conservation_status, habitat_type, diet_type, average_lifespan } = req.body;
    const result = await pool.query(
      'INSERT INTO Species (species_name, scientific_name, conservation_status, habitat_type, diet_type, average_lifespan) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
      [species_name, scientific_name, conservation_status, habitat_type, diet_type, average_lifespan]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to create species' });
  }
});

// ============================================
// FACILITIES ROUTES
// ============================================

// Get all facilities
app.get('/api/facilities', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM Facilities ORDER BY facility_id');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch facilities' });
  }
});

// Get facility by ID
app.get('/api/facilities/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query('SELECT * FROM Facilities WHERE facility_id = $1', [id]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Facility not found' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch facility' });
  }
});

// Create new facility
app.post('/api/facilities', async (req, res) => {
  try {
    const { facility_name, location, facility_type, established_year, capacity, license_number, contact_email, phone_number } = req.body;
    const result = await pool.query(
      'INSERT INTO Facilities (facility_name, location, facility_type, established_year, capacity, license_number, contact_email, phone_number) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *',
      [facility_name, location, facility_type, established_year, capacity, license_number, contact_email, phone_number]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to create facility' });
  }
});

// ============================================
// KEEPERS ROUTES
// ============================================

// Get all keepers
app.get('/api/keepers', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT k.*, f.facility_name 
      FROM Keepers k 
      JOIN Facilities f ON k.facility_id = f.facility_id 
      ORDER BY k.keeper_id
    `);
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch keepers' });
  }
});

// Create new keeper
app.post('/api/keepers', async (req, res) => {
  try {
    const { first_name, last_name, employee_id, specialization, experience_years, certification_level, facility_id, hire_date, salary } = req.body;
    const result = await pool.query(
      'INSERT INTO Keepers (first_name, last_name, employee_id, specialization, experience_years, certification_level, facility_id, hire_date, salary) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *',
      [first_name, last_name, employee_id, specialization, experience_years, certification_level, facility_id, hire_date, salary]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to create keeper' });
  }
});

// ============================================
// ANIMALS ROUTES
// ============================================

// Get all animals with detailed info
app.get('/api/animals', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT 
        a.animal_id, a.animal_name, a.gender, a.birth_date, a.acquisition_date,
        a.acquisition_method, a.health_status, a.weight_kg, a.microchip_id, a.is_active,
        s.species_name, s.scientific_name, s.conservation_status,
        f.facility_name, f.location
      FROM Animals a
      JOIN Species s ON a.species_id = s.species_id
      JOIN Facilities f ON a.facility_id = f.facility_id
      ORDER BY a.animal_id
    `);
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch animals' });
  }
});

// Get animal by ID with full details
app.get('/api/animals/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(`
      SELECT 
        a.*, 
        s.species_name, s.scientific_name, s.conservation_status,
        f.facility_name, f.location,
        getAnimalAgeYears(a.animal_id) as age_years,
        totalMedicalCost(a.animal_id) as total_medical_cost,
        healthRiskScore(a.animal_id) as health_risk_score
      FROM Animals a
      JOIN Species s ON a.species_id = s.species_id
      JOIN Facilities f ON a.facility_id = f.facility_id
      WHERE a.animal_id = $1
    `, [id]);
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Animal not found' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch animal' });
  }
});

// Create new animal using procedure
app.post('/api/animals', async (req, res) => {
  try {
    const { animal_name, species_id, facility_id, gender, birth_date, acquisition_date, acquisition_method, health_status, weight_kg, microchip_id } = req.body;
    
    await pool.query(
      'CALL addAnimal($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)',
      [animal_name, species_id, facility_id, gender, birth_date, acquisition_date, acquisition_method, health_status, weight_kg, microchip_id]
    );
    
    // Fetch the newly created animal
    const result = await pool.query(
      'SELECT * FROM Animals WHERE microchip_id = $1',
      [microchip_id]
    );
    
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message || 'Failed to create animal' });
  }
});

// Update animal
app.put('/api/animals/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const { animal_name, health_status, weight_kg, is_active } = req.body;
    const result = await pool.query(
      'UPDATE Animals SET animal_name = $1, health_status = $2, weight_kg = $3, is_active = $4 WHERE animal_id = $5 RETURNING *',
      [animal_name, health_status, weight_kg, is_active, id]
    );
    
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Animal not found' });
    }
    res.json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to update animal' });
  }
});

// ============================================
// MEDICAL RECORDS ROUTES
// ============================================

// Get medical records for an animal
app.get('/api/animals/:id/medical', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(
      'SELECT * FROM MedicalRecords WHERE animal_id = $1 ORDER BY visit_date DESC',
      [id]
    );
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch medical records' });
  }
});

// Create medical record using procedure
app.post('/api/medical', async (req, res) => {
  try {
    const { animal_id, record_type, cost, diagnosis, treatment, medications, follow_up_date, veterinarian_name } = req.body;
    
    await pool.query(
      'CALL recordMedicalVisit($1, $2, $3, $4, $5, $6, $7, $8)',
      [animal_id, record_type, cost, diagnosis, treatment, medications, follow_up_date, veterinarian_name]
    );
    
    // Fetch the latest medical record for this animal
    const result = await pool.query(
      'SELECT * FROM MedicalRecords WHERE animal_id = $1 ORDER BY record_id DESC LIMIT 1',
      [animal_id]
    );
    
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message || 'Failed to create medical record' });
  }
});

// ============================================
// ANIMAL CARE ROUTES
// ============================================

// Get care assignments for an animal
app.get('/api/animals/:id/care', async (req, res) => {
  try {
    const { id } = req.params;
    const result = await pool.query(`
      SELECT 
        ac.*, 
        k.first_name, k.last_name, k.specialization
      FROM AnimalCare ac
      JOIN Keepers k ON ac.keeper_id = k.keeper_id
      WHERE ac.animal_id = $1
      ORDER BY ac.assignment_date DESC
    `, [id]);
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch care assignments' });
  }
});

// Assign keeper to animal using procedure
app.post('/api/care/assign', async (req, res) => {
  try {
    const { animal_id, keeper_id, notes } = req.body;
    
    await pool.query(
      'CALL assignPrimaryKeeper($1, $2, $3)',
      [animal_id, keeper_id, notes]
    );
    
    // Fetch the latest care assignment
    const result = await pool.query(
      'SELECT * FROM AnimalCare WHERE animal_id = $1 AND is_current = true',
      [animal_id]
    );
    
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: err.message || 'Failed to assign keeper' });
  }
});

// ============================================
// BREEDING RECORDS ROUTES
// ============================================

// Get all breeding records
app.get('/api/breeding', async (req, res) => {
  try {
    const result = await pool.query(`
      SELECT 
        br.*,
        am.animal_name as mother_name,
        af.animal_name as father_name,
        s.species_name
      FROM BreedingRecords br
      JOIN Animals am ON br.mother_id = am.animal_id
      LEFT JOIN Animals af ON br.father_id = af.animal_id
      JOIN Species s ON am.species_id = s.species_id
      ORDER BY br.mating_date DESC
    `);
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch breeding records' });
  }
});

// Create breeding record
app.post('/api/breeding', async (req, res) => {
  try {
    const { mother_id, father_id, mating_date, expected_birth_date, actual_birth_date, number_of_offspring, breeding_success, notes } = req.body;
    const result = await pool.query(
      'INSERT INTO BreedingRecords (mother_id, father_id, mating_date, expected_birth_date, actual_birth_date, number_of_offspring, breeding_success, notes) VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *',
      [mother_id, father_id, mating_date, expected_birth_date, actual_birth_date, number_of_offspring, breeding_success, notes]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to create breeding record' });
  }
});

// ============================================
// DASHBOARD/STATISTICS ROUTES
// ============================================

// Get dashboard statistics
app.get('/api/dashboard/stats', async (req, res) => {
  try {
    const stats = await pool.query(`
      SELECT 
        (SELECT COUNT(*) FROM Animals WHERE is_active = true) as total_animals,
        (SELECT COUNT(*) FROM Species) as total_species,
        (SELECT COUNT(*) FROM Facilities) as total_facilities,
        (SELECT COUNT(*) FROM Keepers) as total_keepers,
        (SELECT COUNT(*) FROM Animals WHERE health_status IN ('Poor', 'Critical')) as animals_needing_attention
    `);
    
    res.json(stats.rows[0]);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch statistics' });
  }
});

// Get active animals view
app.get('/api/views/active-animals', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM ActiveAnimalsView ORDER BY animal_name');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch active animals' });
  }
});

// Get keeper assignments view
app.get('/api/views/keeper-assignments', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM KeeperAssignmentsView ORDER BY last_name, first_name');
    res.json(result.rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch keeper assignments' });
  }
});

// ============================================
// SERVE FRONTEND
// ============================================

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// ============================================
// START SERVER
// ============================================

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
  console.log(`API available at http://localhost:${PORT}/api`);
});
