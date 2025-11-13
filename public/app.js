// API Base URL
const API_URL = 'http://localhost:3000/api';

// Global data storage
let animalsData = [];
let speciesData = [];
let facilitiesData = [];
let keepersData = [];

// Initialize the application
document.addEventListener('DOMContentLoaded', () => {
    loadDashboardStats();
    loadAllData();
    setupEventListeners();
});

// Setup event listeners
function setupEventListeners() {
    // Animal form submission
    document.getElementById('animal-form').addEventListener('submit', handleAddAnimal);
    
    // Medical form submission
    document.getElementById('medical-form').addEventListener('submit', handleAddMedical);
    
    // Species form submission
    document.getElementById('species-form').addEventListener('submit', handleAddSpecies);
    
    // Facility form submission
    document.getElementById('facility-form').addEventListener('submit', handleAddFacility);
    
    // Keeper form submission
    document.getElementById('keeper-form').addEventListener('submit', handleAddKeeper);
}

// Tab switching
function showTab(tabName) {
    // Hide all tabs
    document.querySelectorAll('.tab-content').forEach(tab => {
        tab.classList.remove('active');
    });
    
    // Remove active class from all buttons
    document.querySelectorAll('.tab-button').forEach(button => {
        button.classList.remove('active');
    });
    
    // Show selected tab
    document.getElementById(`${tabName}-tab`).classList.add('active');
    
    // Add active class to clicked button
    event.target.classList.add('active');
    
    // Load data for the selected tab
    switch(tabName) {
        case 'animals':
            loadAnimals();
            break;
        case 'species':
            loadSpecies();
            break;
        case 'facilities':
            loadFacilities();
            break;
        case 'keepers':
            loadKeepers();
            break;
        case 'medical':
            loadMedicalRecords();
            break;
        case 'breeding':
            loadBreedingRecords();
            break;
    }
}

// Load all initial data
async function loadAllData() {
    await Promise.all([
        loadAnimals(),
        loadSpecies(),
        loadFacilities(),
        loadKeepers()
    ]);
    populateFormDropdowns();
}

// Dashboard Statistics
async function loadDashboardStats() {
    try {
        const response = await fetch(`${API_URL}/dashboard/stats`);
        const stats = await response.json();
        
        document.getElementById('total-animals').textContent = stats.total_animals;
        document.getElementById('total-species').textContent = stats.total_species;
        document.getElementById('total-facilities').textContent = stats.total_facilities;
        document.getElementById('total-keepers').textContent = stats.total_keepers;
        document.getElementById('animals-attention').textContent = stats.animals_needing_attention;
    } catch (error) {
        console.error('Error loading dashboard stats:', error);
    }
}

// Animals
async function loadAnimals() {
    try {
        const response = await fetch(`${API_URL}/animals`);
        animalsData = await response.json();
        displayAnimals();
    } catch (error) {
        console.error('Error loading animals:', error);
    }
}

function displayAnimals() {
    const tbody = document.getElementById('animals-tbody');
    tbody.innerHTML = '';
    
    animalsData.forEach(animal => {
        const row = tbody.insertRow();
        row.innerHTML = `
            <td>${animal.animal_id}</td>
            <td><strong>${animal.animal_name}</strong></td>
            <td><em>${animal.species_name}</em></td>
            <td>${animal.facility_name}</td>
            <td>${animal.gender}</td>
            <td><span class="badge badge-${animal.health_status.toLowerCase()}">${animal.health_status}</span></td>
            <td>${animal.weight_kg}</td>
            <td>${animal.microchip_id}</td>
            <td>
                <button class="btn btn-info" onclick="viewAnimalDetails(${animal.animal_id})">Details</button>
            </td>
        `;
    });
}

function showAddAnimalForm() {
    document.getElementById('add-animal-form').style.display = 'block';
}

function hideAddAnimalForm() {
    document.getElementById('add-animal-form').style.display = 'none';
    document.getElementById('animal-form').reset();
}

async function handleAddAnimal(e) {
    e.preventDefault();
    
    const formData = {
        animal_name: document.getElementById('animal_name').value,
        species_id: parseInt(document.getElementById('species_id').value),
        facility_id: parseInt(document.getElementById('facility_id').value),
        gender: document.getElementById('gender').value,
        birth_date: document.getElementById('birth_date').value || null,
        acquisition_date: document.getElementById('acquisition_date').value,
        acquisition_method: document.getElementById('acquisition_method').value,
        health_status: document.getElementById('health_status').value,
        weight_kg: parseFloat(document.getElementById('weight_kg').value),
        microchip_id: document.getElementById('microchip_id').value
    };
    
    try {
        const response = await fetch(`${API_URL}/animals`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(formData)
        });
        
        if (response.ok) {
            alert('Animal added successfully!');
            hideAddAnimalForm();
            loadAnimals();
            loadDashboardStats();
        } else {
            const error = await response.json();
            alert('Error: ' + error.error);
        }
    } catch (error) {
        console.error('Error adding animal:', error);
        alert('Failed to add animal');
    }
}

async function viewAnimalDetails(animalId) {
    try {
        const response = await fetch(`${API_URL}/animals/${animalId}`);
        const animal = await response.json();
        
        const modal = document.getElementById('animal-modal');
        document.getElementById('modal-animal-name').textContent = animal.animal_name;
        
        const detailsHtml = `
            <div class="detail-grid">
                <div class="detail-item">
                    <div class="detail-label">Species</div>
                    <div class="detail-value">${animal.species_name}</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Scientific Name</div>
                    <div class="detail-value"><em>${animal.scientific_name}</em></div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Conservation Status</div>
                    <div class="detail-value">${animal.conservation_status}</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Facility</div>
                    <div class="detail-value">${animal.facility_name}</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Gender</div>
                    <div class="detail-value">${animal.gender}</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Age</div>
                    <div class="detail-value">${animal.age_years} years</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Health Status</div>
                    <div class="detail-value"><span class="badge badge-${animal.health_status.toLowerCase()}">${animal.health_status}</span></div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Weight</div>
                    <div class="detail-value">${animal.weight_kg} kg</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Microchip ID</div>
                    <div class="detail-value">${animal.microchip_id}</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Health Risk Score</div>
                    <div class="detail-value">${animal.health_risk_score}/8</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Total Medical Cost</div>
                    <div class="detail-value">$${parseFloat(animal.total_medical_cost).toFixed(2)}</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Acquisition Method</div>
                    <div class="detail-value">${animal.acquisition_method}</div>
                </div>
            </div>
        `;
        
        document.getElementById('modal-animal-details').innerHTML = detailsHtml;
        modal.style.display = 'block';
    } catch (error) {
        console.error('Error loading animal details:', error);
    }
}

function closeAnimalModal() {
    document.getElementById('animal-modal').style.display = 'none';
}

// Species
async function loadSpecies() {
    try {
        const response = await fetch(`${API_URL}/species`);
        speciesData = await response.json();
        displaySpecies();
    } catch (error) {
        console.error('Error loading species:', error);
    }
}

function displaySpecies() {
    const tbody = document.getElementById('species-tbody');
    tbody.innerHTML = '';
    
    speciesData.forEach(species => {
        const row = tbody.insertRow();
        row.innerHTML = `
            <td>${species.species_id}</td>
            <td><strong>${species.species_name}</strong></td>
            <td><em>${species.scientific_name}</em></td>
            <td><span class="badge badge-${getConservationClass(species.conservation_status)}">${species.conservation_status}</span></td>
            <td>${species.habitat_type}</td>
            <td>${species.diet_type}</td>
            <td>${species.average_lifespan}</td>
        `;
    });
}

function getConservationClass(status) {
    if (status.includes('Endangered')) return 'endangered';
    if (status === 'Vulnerable') return 'vulnerable';
    return 'good';
}

// Facilities
async function loadFacilities() {
    try {
        const response = await fetch(`${API_URL}/facilities`);
        facilitiesData = await response.json();
        displayFacilities();
    } catch (error) {
        console.error('Error loading facilities:', error);
    }
}

function displayFacilities() {
    const tbody = document.getElementById('facilities-tbody');
    tbody.innerHTML = '';
    
    facilitiesData.forEach(facility => {
        const row = tbody.insertRow();
        row.innerHTML = `
            <td>${facility.facility_id}</td>
            <td><strong>${facility.facility_name}</strong></td>
            <td>${facility.location}</td>
            <td>${facility.facility_type}</td>
            <td>${facility.established_year}</td>
            <td>${facility.capacity}</td>
            <td>${facility.license_number}</td>
            <td>${facility.contact_email || 'N/A'}<br>${facility.phone_number || ''}</td>
        `;
    });
}

// Keepers
async function loadKeepers() {
    try {
        const response = await fetch(`${API_URL}/keepers`);
        keepersData = await response.json();
        displayKeepers();
    } catch (error) {
        console.error('Error loading keepers:', error);
    }
}

function displayKeepers() {
    const tbody = document.getElementById('keepers-tbody');
    tbody.innerHTML = '';
    
    keepersData.forEach(keeper => {
        const row = tbody.insertRow();
        row.innerHTML = `
            <td>${keeper.keeper_id}</td>
            <td><strong>${keeper.first_name} ${keeper.last_name}</strong></td>
            <td>${keeper.employee_id}</td>
            <td>${keeper.specialization || 'General'}</td>
            <td>${keeper.experience_years}</td>
            <td><span class="badge badge-${keeper.certification_level.toLowerCase()}">${keeper.certification_level}</span></td>
            <td>${keeper.facility_name}</td>
            <td>${new Date(keeper.hire_date).toLocaleDateString()}</td>
        `;
    });
}

// Medical Records
function showAddMedicalForm() {
    document.getElementById('add-medical-form').style.display = 'block';
}

function hideAddMedicalForm() {
    document.getElementById('add-medical-form').style.display = 'none';
    document.getElementById('medical-form').reset();
}

async function handleAddMedical(e) {
    e.preventDefault();
    
    const formData = {
        animal_id: parseInt(document.getElementById('medical_animal_id').value),
        veterinarian_name: document.getElementById('veterinarian_name').value,
        record_type: document.getElementById('record_type').value,
        cost: parseFloat(document.getElementById('cost').value),
        diagnosis: document.getElementById('diagnosis').value,
        treatment: document.getElementById('treatment').value,
        medications: document.getElementById('medications').value || null,
        follow_up_date: document.getElementById('follow_up_date').value || null
    };
    
    try {
        const response = await fetch(`${API_URL}/medical`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(formData)
        });
        
        if (response.ok) {
            alert('Medical record added successfully!');
            hideAddMedicalForm();
            loadMedicalRecords();
            loadDashboardStats();
        } else {
            const error = await response.json();
            alert('Error: ' + error.error);
        }
    } catch (error) {
        console.error('Error adding medical record:', error);
        alert('Failed to add medical record');
    }
}

async function loadMedicalRecords() {
    // This is a placeholder - in a full implementation, you'd select an animal first
    document.getElementById('medical-records-container').innerHTML = 
        '<p class="info-message">Select an animal to view medical records or add a new record using the button above.</p>';
}

// Breeding Records
async function loadBreedingRecords() {
    try {
        const response = await fetch(`${API_URL}/breeding`);
        const breedingData = await response.json();
        displayBreedingRecords(breedingData);
    } catch (error) {
        console.error('Error loading breeding records:', error);
    }
}

function displayBreedingRecords(data) {
    const tbody = document.getElementById('breeding-tbody');
    tbody.innerHTML = '';
    
    data.forEach(record => {
        const row = tbody.insertRow();
        row.innerHTML = `
            <td>${record.breeding_id}</td>
            <td>${record.mother_name}</td>
            <td>${record.father_name || 'Unknown'}</td>
            <td><em>${record.species_name}</em></td>
            <td>${new Date(record.mating_date).toLocaleDateString()}</td>
            <td>${record.expected_birth_date ? new Date(record.expected_birth_date).toLocaleDateString() : 'N/A'}</td>
            <td>${record.actual_birth_date ? new Date(record.actual_birth_date).toLocaleDateString() : 'Pending'}</td>
            <td>${record.number_of_offspring}</td>
            <td><span class="badge badge-${record.breeding_success ? 'success' : 'failure'}">${record.breeding_success ? 'Yes' : 'No'}</span></td>
        `;
    });
}

// Populate form dropdowns
function populateFormDropdowns() {
    // Populate species dropdown
    const speciesSelect = document.getElementById('species_id');
    speciesSelect.innerHTML = '<option value="">Select Species</option>';
    speciesData.forEach(species => {
        const option = document.createElement('option');
        option.value = species.species_id;
        option.textContent = species.species_name;
        speciesSelect.appendChild(option);
    });
    
    // Populate facility dropdown
    const facilitySelect = document.getElementById('facility_id');
    facilitySelect.innerHTML = '<option value="">Select Facility</option>';
    facilitiesData.forEach(facility => {
        const option = document.createElement('option');
        option.value = facility.facility_id;
        option.textContent = facility.facility_name;
        facilitySelect.appendChild(option);
    });
    
    // Populate animal dropdown for medical records
    const animalSelect = document.getElementById('medical_animal_id');
    animalSelect.innerHTML = '<option value="">Select Animal</option>';
    animalsData.forEach(animal => {
        const option = document.createElement('option');
        option.value = animal.animal_id;
        option.textContent = `${animal.animal_name} (${animal.species_name})`;
        animalSelect.appendChild(option);
    });
}

// ============================================
// SPECIES FORM FUNCTIONS
// ============================================

function showAddSpeciesForm() {
    document.getElementById('add-species-form').style.display = 'block';
}

function hideAddSpeciesForm() {
    document.getElementById('add-species-form').style.display = 'none';
    document.getElementById('species-form').reset();
}

async function handleAddSpecies(e) {
    e.preventDefault();
    
    const formData = {
        species_name: document.getElementById('species_name').value,
        scientific_name: document.getElementById('scientific_name').value,
        conservation_status: document.getElementById('conservation_status').value,
        habitat_type: document.getElementById('habitat_type').value,
        diet_type: document.getElementById('diet_type').value,
        average_lifespan: parseInt(document.getElementById('average_lifespan').value)
    };
    
    try {
        const response = await fetch(`${API_URL}/species`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(formData)
        });
        
        if (response.ok) {
            alert('Species added successfully!');
            hideAddSpeciesForm();
            loadSpecies();
            loadDashboardStats();
            // Reload animals data to update dropdowns
            loadAllData();
        } else {
            const error = await response.json();
            alert('Error: ' + error.error);
        }
    } catch (error) {
        console.error('Error adding species:', error);
        alert('Failed to add species');
    }
}

// ============================================
// FACILITY FORM FUNCTIONS
// ============================================

function showAddFacilityForm() {
    document.getElementById('add-facility-form').style.display = 'block';
}

function hideAddFacilityForm() {
    document.getElementById('add-facility-form').style.display = 'none';
    document.getElementById('facility-form').reset();
}

async function handleAddFacility(e) {
    e.preventDefault();
    
    const formData = {
        facility_name: document.getElementById('facility_name').value,
        location: document.getElementById('location').value,
        facility_type: document.getElementById('facility_type').value,
        established_year: parseInt(document.getElementById('established_year').value),
        capacity: parseInt(document.getElementById('capacity').value),
        license_number: document.getElementById('license_number').value,
        contact_email: document.getElementById('contact_email').value || null,
        phone_number: document.getElementById('phone_number').value || null
    };
    
    try {
        const response = await fetch(`${API_URL}/facilities`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(formData)
        });
        
        if (response.ok) {
            alert('Facility added successfully!');
            hideAddFacilityForm();
            loadFacilities();
            loadDashboardStats();
            // Reload animals data to update dropdowns
            loadAllData();
        } else {
            const error = await response.json();
            alert('Error: ' + error.error);
        }
    } catch (error) {
        console.error('Error adding facility:', error);
        alert('Failed to add facility');
    }
}

// ============================================
// KEEPER FORM FUNCTIONS
// ============================================

function showAddKeeperForm() {
    document.getElementById('add-keeper-form').style.display = 'block';
    // Populate keeper facility dropdown
    const keeperFacilitySelect = document.getElementById('keeper_facility_id');
    keeperFacilitySelect.innerHTML = '<option value="">Select Facility</option>';
    facilitiesData.forEach(facility => {
        const option = document.createElement('option');
        option.value = facility.facility_id;
        option.textContent = facility.facility_name;
        keeperFacilitySelect.appendChild(option);
    });
}

function hideAddKeeperForm() {
    document.getElementById('add-keeper-form').style.display = 'none';
    document.getElementById('keeper-form').reset();
}

async function handleAddKeeper(e) {
    e.preventDefault();
    
    const formData = {
        first_name: document.getElementById('first_name').value,
        last_name: document.getElementById('last_name').value,
        employee_id: document.getElementById('employee_id').value,
        specialization: document.getElementById('specialization').value || null,
        experience_years: parseInt(document.getElementById('experience_years').value),
        certification_level: document.getElementById('certification_level').value,
        facility_id: parseInt(document.getElementById('keeper_facility_id').value),
        hire_date: document.getElementById('hire_date').value,
        salary: parseFloat(document.getElementById('salary').value)
    };
    
    try {
        const response = await fetch(`${API_URL}/keepers`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(formData)
        });
        
        if (response.ok) {
            alert('Keeper added successfully!');
            hideAddKeeperForm();
            loadKeepers();
            loadDashboardStats();
        } else {
            const error = await response.json();
            alert('Error: ' + error.error);
        }
    } catch (error) {
        console.error('Error adding keeper:', error);
        alert('Failed to add keeper');
    }
}

// Close modal when clicking outside
window.onclick = function(event) {
    const modal = document.getElementById('animal-modal');
    if (event.target === modal) {
        modal.style.display = 'none';
    }
}
