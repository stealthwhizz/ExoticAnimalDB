DROP DATABASE IF EXISTS ExoticAnimalDB;
CREATE DATABASE ExoticAnimalDB;
USE ExoticAnimalDB;

CREATE TABLE Species (
    species_id INT AUTO_INCREMENT,
    species_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(150) NOT NULL UNIQUE,
    conservation_status ENUM('Least Concern', 'Near Threatened', 'Vulnerable', 'Endangered', 'Critically Endangered', 'Extinct') DEFAULT 'Least Concern',
    habitat_type VARCHAR(100) NOT NULL,
    diet_type ENUM('Carnivore', 'Herbivore', 'Omnivore', 'Insectivore') NOT NULL,
    average_lifespan INT CHECK (average_lifespan > 0),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (species_id),
    CONSTRAINT chk_lifespan CHECK (average_lifespan BETWEEN 1 AND 200)
);

CREATE TABLE Facilities (
    facility_id INT AUTO_INCREMENT,
    facility_name VARCHAR(200) NOT NULL,
    location VARCHAR(200) NOT NULL,
    facility_type ENUM('Zoo', 'Wildlife Sanctuary', 'Aquarium', 'Research Center') NOT NULL,
    established_year INT NOT NULL,
    capacity INT NOT NULL CHECK (capacity > 0),
    license_number VARCHAR(50) NOT NULL UNIQUE,
    contact_email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20),
    PRIMARY KEY (facility_id),
    CONSTRAINT chk_established_year CHECK (established_year BETWEEN 1800 AND 2025),
    CONSTRAINT chk_capacity CHECK (capacity BETWEEN 1 AND 10000)
);

CREATE TABLE Keepers (
    keeper_id INT AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    employee_id VARCHAR(20) NOT NULL UNIQUE,
    specialization VARCHAR(100),
    experience_years INT DEFAULT 0,
    certification_level ENUM('Beginner', 'Intermediate', 'Advanced', 'Expert') DEFAULT 'Beginner',
    facility_id INT NOT NULL,
    hire_date DATE NOT NULL,
    salary DECIMAL(10,2) CHECK (salary > 0),
    PRIMARY KEY (keeper_id),
    FOREIGN KEY (facility_id) REFERENCES Facilities(facility_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_experience CHECK (experience_years >= 0 AND experience_years <= 50),
    CONSTRAINT chk_salary CHECK (salary BETWEEN 20000 AND 200000)
);

CREATE TABLE Animals (
    animal_id INT AUTO_INCREMENT,
    animal_name VARCHAR(100) NOT NULL,
    species_id INT NOT NULL,
    facility_id INT NOT NULL,
    gender ENUM('Male', 'Female', 'Unknown') NOT NULL,
    birth_date DATE,
    acquisition_date DATE NOT NULL,
    acquisition_method ENUM('Born in facility', 'Purchased', 'Rescued', 'Transferred', 'Donated') NOT NULL,
    health_status ENUM('Excellent', 'Good', 'Fair', 'Poor', 'Critical') DEFAULT 'Good',
    weight_kg DECIMAL(8,2) CHECK (weight_kg > 0),
    microchip_id VARCHAR(20) UNIQUE,
    is_active BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (animal_id),
    FOREIGN KEY (species_id) REFERENCES Species(species_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (facility_id) REFERENCES Facilities(facility_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_weight CHECK (weight_kg BETWEEN 0.001 AND 10000)
);

CREATE TABLE AnimalCare (
    care_id INT AUTO_INCREMENT,
    animal_id INT NOT NULL,
    keeper_id INT NOT NULL,
    assignment_date DATE NOT NULL,
    care_type ENUM('Primary', 'Secondary', 'Temporary', 'Emergency') DEFAULT 'Primary',
    notes TEXT,
    is_current BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (care_id),
    FOREIGN KEY (animal_id) REFERENCES Animals(animal_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (keeper_id) REFERENCES Keepers(keeper_id) ON DELETE CASCADE ON UPDATE CASCADE,
    INDEX idx_animal_keeper (animal_id, keeper_id)
);

CREATE TABLE MedicalRecords (
    record_id INT AUTO_INCREMENT,
    animal_id INT NOT NULL,
    visit_date DATE NOT NULL,
    veterinarian_name VARCHAR(100) NOT NULL,
    diagnosis TEXT,
    treatment TEXT,
    medications VARCHAR(500),
    follow_up_date DATE,
    record_type ENUM('Routine Checkup', 'Emergency', 'Surgery', 'Vaccination', 'Injury') NOT NULL,
    cost DECIMAL(10,2) DEFAULT 0,
    PRIMARY KEY (record_id),
    FOREIGN KEY (animal_id) REFERENCES Animals(animal_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_medical_cost CHECK (cost >= 0)
);

CREATE TABLE BreedingRecords (
    breeding_id INT AUTO_INCREMENT,
    mother_id INT NOT NULL,
    father_id INT,
    mating_date DATE NOT NULL,
    expected_birth_date DATE,
    actual_birth_date DATE,
    number_of_offspring INT DEFAULT 0,
    breeding_success BOOLEAN DEFAULT FALSE,
    notes TEXT,
    PRIMARY KEY (breeding_id),
    FOREIGN KEY (mother_id) REFERENCES Animals(animal_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (father_id) REFERENCES Animals(animal_id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_offspring_count CHECK (number_of_offspring >= 0 AND number_of_offspring <= 20)
);

INSERT INTO Species (species_name, scientific_name, conservation_status, habitat_type, diet_type, average_lifespan) VALUES
('Bengal Tiger', 'Panthera tigris tigris', 'Endangered', 'Tropical Forest', 'Carnivore', 15),
('African Elephant', 'Loxodonta africana', 'Endangered', 'Savanna', 'Herbivore', 60),
('Snow Leopard', 'Panthera uncia', 'Vulnerable', 'Mountain', 'Carnivore', 18),
('Giant Panda', 'Ailuropoda melanoleuca', 'Vulnerable', 'Bamboo Forest', 'Herbivore', 20),
('Galapagos Tortoise', 'Chelonoidis nigra', 'Vulnerable', 'Island', 'Herbivore', 100),
('Red Panda', 'Ailurus fulgens', 'Endangered', 'Temperate Forest', 'Omnivore', 14),
('Komodo Dragon', 'Varanus komodoensis', 'Vulnerable', 'Tropical Island', 'Carnivore', 30);

INSERT INTO Facilities (facility_name, location, facility_type, established_year, capacity, license_number, contact_email, phone_number) VALUES
('Wildlife Conservation Zoo', 'Bangalore, Karnataka', 'Zoo', 1995, 500, 'WCZ-KA-001', 'info@wczbangalore.org', '+91-80-12345678'),
('Marine Life Aquarium', 'Mumbai, Maharashtra', 'Aquarium', 2003, 300, 'MLA-MH-002', 'contact@marinelife.in', '+91-22-87654321'),
('Himalayan Wildlife Sanctuary', 'Shimla, Himachal Pradesh', 'Wildlife Sanctuary', 1987, 200, 'HWS-HP-003', 'admin@himalayanwildlife.org', '+91-177-98765432'),
('Tropical Research Center', 'Goa', 'Research Center', 2010, 150, 'TRC-GA-004', 'research@tropicalcenter.edu', '+91-832-56789012'),
('Desert Wildlife Park', 'Jaisalmer, Rajasthan', 'Zoo', 1999, 400, 'DWP-RJ-005', 'info@desertwildlife.com', '+91-2992-123456');

INSERT INTO Keepers (first_name, last_name, employee_id, specialization, experience_years, certification_level, facility_id, hire_date, salary) VALUES
('Rajesh', 'Kumar', 'WCZ001', 'Big Cats', 12, 'Expert', 1, '2015-03-15', 65000.00),
('Priya', 'Sharma', 'WCZ002', 'Herbivores', 8, 'Advanced', 1, '2018-07-22', 55000.00),
('Ahmed', 'Ali', 'MLA001', 'Marine Animals', 15, 'Expert', 2, '2012-01-10', 70000.00),
('Sneha', 'Patel', 'HWS001', 'Mountain Wildlife', 10, 'Advanced', 3, '2016-05-08', 58000.00),
('Vikram', 'Singh', 'TRC001', 'Reptiles', 6, 'Intermediate', 4, '2020-09-12', 48000.00),
('Meera', 'Nair', 'DWP001', 'Desert Animals', 9, 'Advanced', 5, '2017-11-20', 52000.00),
('Arjun', 'Reddy', 'WCZ003', 'Primates', 4, 'Intermediate', 1, '2021-02-14', 42000.00);

INSERT INTO Animals (animal_name, species_id, facility_id, gender, birth_date, acquisition_date, acquisition_method, health_status, weight_kg, microchip_id) VALUES
('Shera', 1, 1, 'Male', '2018-05-12', '2018-05-12', 'Born in facility', 'Excellent', 220.50, 'MC001'),
('Rani', 1, 1, 'Female', '2017-03-08', '2019-06-15', 'Transferred', 'Good', 180.75, 'MC002'),
('Gajraj', 2, 1, 'Male', '2010-08-20', '2012-04-10', 'Rescued', 'Good', 4500.00, 'MC003'),
('Hima', 3, 3, 'Female', '2016-12-03', '2020-01-15', 'Purchased', 'Excellent', 45.30, 'MC004'),
('Baloo', 4, 3, 'Male', '2019-09-18', '2019-09-18', 'Born in facility', 'Good', 120.80, 'MC005'),
('Ruby', 6, 4, 'Female', '2020-11-22', '2021-03-10', 'Donated', 'Fair', 6.20, 'MC006'),
('Rex', 7, 4, 'Male', '2015-07-14', '2018-08-25', 'Transferred', 'Good', 85.40, 'MC007'),
('Luna', 3, 3, 'Female', '2018-04-05', '2021-07-12', 'Purchased', 'Excellent', 38.90, 'MC008');

INSERT INTO AnimalCare (animal_id, keeper_id, assignment_date, care_type, notes) VALUES
(1, 1, '2019-06-15', 'Primary', 'Experienced with big cats'),
(2, 1, '2019-06-15', 'Primary', 'Same keeper for breeding pair'),
(3, 2, '2012-04-10', 'Primary', 'Elephant specialist'),
(4, 4, '2020-01-15', 'Primary', 'Mountain wildlife expert'),
(5, 4, '2019-09-18', 'Primary', 'Panda care specialist'),
(6, 5, '2021-03-10', 'Primary', 'Small mammal care'),
(7, 5, '2018-08-25', 'Primary', 'Reptile specialist'),
(8, 4, '2021-07-12', 'Secondary', 'Backup care for snow leopards');

INSERT INTO MedicalRecords (animal_id, visit_date, veterinarian_name, diagnosis, treatment, medications, record_type, cost) VALUES
(1, '2023-01-15', 'Dr. Ramesh Gupta', 'Routine health check', 'General examination, vaccinations', 'Multivitamins, Deworming tablets', 'Routine Checkup', 2500.00),
(2, '2023-02-20', 'Dr. Ramesh Gupta', 'Minor cut on paw', 'Cleaned wound, applied antiseptic', 'Antibiotics, Pain relief', 'Injury', 1800.00),
(3, '2023-01-10', 'Dr. Sunita Verma', 'Annual health assessment', 'Complete physical exam', 'Vitamin supplements', 'Routine Checkup', 3500.00),
(4, '2023-03-05', 'Dr. Arvind Kumar', 'Dental examination', 'Teeth cleaning, minor dental work', 'Anti-inflammatory medication', 'Routine Checkup', 2200.00),
(5, '2023-02-28', 'Dr. Meena Joshi', 'Digestive issues', 'Dietary adjustment recommended', 'Probiotics, Digestive enzymes', 'Emergency', 1500.00),
(6, '2023-01-25', 'Dr. Pradeep Singh', 'Vaccination schedule', 'Annual vaccinations completed', 'Vaccines as per schedule', 'Vaccination', 800.00),
(7, '2023-03-12', 'Dr. Kavita Nair', 'Skin condition', 'Fungal infection treatment', 'Antifungal medication, Medicated bath', 'Emergency', 2800.00);

INSERT INTO BreedingRecords (mother_id, father_id, mating_date, expected_birth_date, actual_birth_date, number_of_offspring, breeding_success, notes) VALUES
(2, 1, '2022-12-15', '2023-03-20', '2023-03-22', 2, TRUE, 'Successful breeding of Bengal tigers'),
(4, NULL, '2022-08-10', '2023-02-15', NULL, 0, FALSE, 'Artificial insemination attempt unsuccessful'),
(6, NULL, '2023-01-20', '2023-05-25', NULL, 0, FALSE, 'Natural breeding attempt, monitoring required');

CREATE INDEX idx_animals_species ON Animals(species_id);
CREATE INDEX idx_animals_facility ON Animals(facility_id);
CREATE INDEX idx_medical_animal_date ON MedicalRecords(animal_id, visit_date);
CREATE INDEX idx_keepers_facility ON Keepers(facility_id);
CREATE INDEX idx_breeding_mother ON BreedingRecords(mother_id);

CREATE VIEW ActiveAnimalsView AS
SELECT 
    a.animal_id,
    a.animal_name,
    s.species_name,
    s.scientific_name,
    f.facility_name,
    a.gender,
    a.health_status,
    a.weight_kg
FROM Animals a
JOIN Species s ON a.species_id = s.species_id
JOIN Facilities f ON a.facility_id = f.facility_id
WHERE a.is_active = TRUE;

CREATE VIEW KeeperAssignmentsView AS
SELECT 
    k.first_name,
    k.last_name,
    k.specialization,
    a.animal_name,
    s.species_name,
    ac.care_type,
    ac.assignment_date
FROM Keepers k
JOIN AnimalCare ac ON k.keeper_id = ac.keeper_id
JOIN Animals a ON ac.animal_id = a.animal_id
JOIN Species s ON a.species_id = s.species_id
WHERE ac.is_current = TRUE;

-- ==========================
-- FUNCTIONS
-- ==========================
DELIMITER //

CREATE FUNCTION getAnimalAgeYears(p_animal_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE bdate DATE;
  DECLARE yrs INT;
  SELECT birthdate INTO bdate FROM Animals WHERE animalid = p_animal_id;
  IF bdate IS NULL THEN
    SET yrs = 0;
  ELSE
    SET yrs = TIMESTAMPDIFF(YEAR, bdate, CURDATE());
  END IF;
  RETURN yrs;
END//

CREATE FUNCTION totalMedicalCost(p_animal_id INT)
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
  DECLARE total DECIMAL(12,2);
  SELECT IFNULL(SUM(cost), 0) INTO total
  FROM MedicalRecords
  WHERE animalid = p_animal_id;
  RETURN total;
END//

CREATE FUNCTION healthRiskScore(p_animal_id INT)
RETURNS INT
DETERMINISTIC
BEGIN
  DECLARE status VARCHAR(50);
  DECLARE base INT DEFAULT 0;
  DECLARE recent_emergencies INT DEFAULT 0;

  SELECT s.conservationstatus INTO status
  FROM Animals a
  JOIN Species s ON a.speciesid = s.speciesid
  WHERE a.animalid = p_animal_id;

  IF status IN ('Critically Endangered') THEN SET base = 5;
  ELSEIF status IN ('Endangered') THEN SET base = 4;
  ELSEIF status IN ('Vulnerable') THEN SET base = 3;
  ELSEIF status IN ('Near Threatened') THEN SET base = 2;
  ELSE SET base = 1;
  END IF;

  SELECT COUNT(*) INTO recent_emergencies
  FROM MedicalRecords
  WHERE animalid = p_animal_id
    AND recordtype IN ('Emergency','Surgery')
    AND visitdate >= DATE_SUB(CURDATE(), INTERVAL 180 DAY);

  RETURN base + LEAST(recent_emergencies, 3);
END//

DELIMITER ;

-- ==========================
-- PROCEDURES
-- ==========================
DELIMITER //

CREATE PROCEDURE addAnimal(
  IN p_animalname VARCHAR(100),
  IN p_speciesid INT,
  IN p_facilityid INT,
  IN p_gender ENUM('Male','Female','Unknown'),
  IN p_birthdate DATE,
  IN p_acquisitiondate DATE,
  IN p_acquisitionmethod ENUM('Born in facility','Purchased','Rescued','Transferred','Donated'),
  IN p_healthstatus ENUM('Excellent','Good','Fair','Poor','Critical'),
  IN p_weightkg DECIMAL(8,2),
  IN p_microchipid VARCHAR(20)
)
BEGIN
  DECLARE cap INT; DECLARE current_count INT;

  IF (SELECT COUNT(*) FROM Species WHERE speciesid = p_speciesid) = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid speciesid';
  END IF;

  IF (SELECT COUNT(*) FROM Facilities WHERE facilityid = p_facilityid) = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid facilityid';
  END IF;

  SELECT capacity INTO cap FROM Facilities WHERE facilityid = p_facilityid;
  SELECT COUNT(*) INTO current_count FROM Animals WHERE facilityid = p_facilityid AND isactive = TRUE;
  IF current_count >= cap THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Facility capacity exceeded';
  END IF;

  INSERT INTO Animals(
    animalname, speciesid, facilityid, gender, birthdate, acquisitiondate,
    acquisitionmethod, healthstatus, weightkg, microchipid, isactive
  ) VALUES (
    p_animalname, p_speciesid, p_facilityid, p_gender, p_birthdate, p_acquisitiondate,
    p_acquisitionmethod, p_healthstatus, p_weightkg, p_microchipid, TRUE
  );
END//

CREATE PROCEDURE assignPrimaryKeeper(
  IN p_animal_id INT,
  IN p_keeper_id INT,
  IN p_notes TEXT
)
BEGIN
  IF (SELECT COUNT(*) FROM Animals WHERE animalid = p_animal_id AND isactive=TRUE) = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid or inactive animal';
  END IF;
  IF (SELECT COUNT(*) FROM Keepers WHERE keeperid = p_keeper_id) = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid keeper';
  END IF;

  UPDATE AnimalCare
  SET iscurrent = FALSE
  WHERE animalid = p_animal_id AND iscurrent = TRUE;

  INSERT INTO AnimalCare(animalid, keeperid, assignmentdate, caretype, notes, iscurrent)
  VALUES (p_animal_id, p_keeper_id, CURDATE(), 'Primary', p_notes, TRUE);
END//

CREATE PROCEDURE recordMedicalVisit(
  IN p_animal_id INT,
  IN p_recordtype ENUM('Routine Checkup','Emergency','Surgery','Vaccination','Injury'),
  IN p_cost DECIMAL(10,2),
  IN p_diagnosis TEXT,
  IN p_treatment TEXT,
  IN p_medications VARCHAR(500),
  IN p_followupdate DATE,
  IN p_veterinarianname VARCHAR(100)
)
BEGIN
  IF (SELECT COUNT(*) FROM Animals WHERE animalid=p_animal_id) = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid animal';
  END IF;
  IF p_cost < 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Negative cost not allowed';
  END IF;

  INSERT INTO MedicalRecords(
    animalid, visitdate, veterinarianname, diagnosis, treatment, medications,
    followupdate, recordtype, cost
  ) VALUES (
    p_animal_id, CURDATE(), p_veterinarianname, p_diagnosis, p_treatment, p_medications,
    p_followupdate, p_recordtype, p_cost
  );

  IF p_recordtype IN ('Emergency','Surgery') THEN
    UPDATE Animals SET healthstatus = 'Poor' WHERE animalid = p_animal_id AND healthstatus IN ('Good','Fair','Excellent');
  END IF;
END//

DELIMITER ;

-- ==========================
-- TRIGGERS
-- ==========================
DELIMITER //

-- Enforce weight bounds
CREATE TRIGGER trg_animals_weight_check
BEFORE INSERT ON Animals
FOR EACH ROW
BEGIN
  IF NEW.weightkg IS NOT NULL AND (NEW.weightkg < 0.001 OR NEW.weightkg > 10000) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Weight out of allowed bounds';
  END IF;
END//

CREATE TRIGGER trg_animals_weight_check_upd
BEFORE UPDATE ON Animals
FOR EACH ROW
BEGIN
  IF NEW.weightkg IS NOT NULL AND (NEW.weightkg < 0.001 OR NEW.weightkg > 10000) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Weight out of allowed bounds';
  END IF;
END//

-- Guard facility capacity
CREATE TRIGGER trg_facility_capacity
BEFORE INSERT ON Animals
FOR EACH ROW
BEGIN
  DECLARE cap INT; DECLARE cnt INT;
  SELECT capacity INTO cap FROM Facilities WHERE facilityid = NEW.facilityid;
  SELECT COUNT(*) INTO cnt FROM Animals WHERE facilityid = NEW.facilityid AND isactive = TRUE;
  IF cnt >= cap THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Facility capacity exceeded (trigger)';
  END IF;
END//

-- Only one current Primary keeper per animal
CREATE TRIGGER trg_animalcare_primary_uniqueness
BEFORE INSERT ON AnimalCare
FOR EACH ROW
BEGIN
  IF NEW.iscurrent = TRUE AND NEW.caretype = 'Primary' THEN
    IF EXISTS (
      SELECT 1 FROM AnimalCare
      WHERE animalid = NEW.animalid AND iscurrent = TRUE AND caretype = 'Primary'
    ) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Primary current keeper already exists for this animal';
    END IF;
  END IF;
END//

CREATE TRIGGER trg_animalcare_primary_uniqueness_upd
BEFORE UPDATE ON AnimalCare
FOR EACH ROW
BEGIN
  IF NEW.iscurrent = TRUE AND NEW.caretype = 'Primary' THEN
    IF EXISTS (
      SELECT 1 FROM AnimalCare
      WHERE animalid = NEW.animalid AND iscurrent = TRUE AND caretype = 'Primary' AND careid <> NEW.careid
    ) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Primary current keeper already exists for this animal';
    END IF;
  END IF;
END//

DELIMITER ;


COMMIT;

-- DEMO CALLS (uncomment to test locally)
-- SELECT animalname, getAnimalAgeYears(animalid) AS age_years,
--        totalMedicalCost(animalid) AS total_cost,
--        healthRiskScore(animalid) AS risk
-- FROM Animals
-- ORDER BY risk DESC;

-- CALL addAnimal('Khan', 1, 1, 'Male', '2022-01-01', CURDATE(), 'Transferred', 'Good', 210.00, 'MC999');
-- SELECT * FROM Animals WHERE microchipid='MC999';

-- CALL assignPrimaryKeeper(1, 1, 'Reassigned for medical monitoring');
-- SELECT * FROM AnimalCare WHERE animalid=1 ORDER BY assignmentdate DESC;

-- CALL recordMedicalVisit(1, 'Emergency', 3200.00, 'Dehydration', 'Fluids', 'ORS', DATE_ADD(CURDATE(), INTERVAL 7 DAY), 'Dr. N Rao');
-- SELECT * FROM MedicalRecords WHERE animalid=1 ORDER BY visitdate DESC;
-- SELECT animalname, healthstatus FROM Animals WHERE animalid=1;

-- -- Trigger error demos:
-- UPDATE Animals SET weightkg = -5 WHERE animalid=1; -- expect error
-- INSERT INTO AnimalCare(animalid, keeperid, assignmentdate, caretype, notes, iscurrent)
-- VALUES (1, 2, CURDATE(), 'Primary', 'Conflict test', TRUE); -- expect error

-- -- Capacity trigger demo (restore capacity afterwards)
-- UPDATE Facilities SET capacity = 1 WHERE facilityid=1;
-- INSERT INTO Animals(animalname, speciesid, facilityid, gender, acquisitiondate, acquisitionmethod, healthstatus, weightkg, microchipid, isactive)
-- VALUES ('TestCap', 1, 1, 'Male', CURDATE(), 'Transferred', 'Good', 100.00, 'MCTEST', TRUE); -- expect error
-- UPDATE Facilities SET capacity = 500 WHERE facilityid=1;

