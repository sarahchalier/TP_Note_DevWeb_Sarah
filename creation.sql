-- 2. Schéma de la base de données

DROP TABLE IF EXISTS prescriptions CASCADE;
DROP TABLE IF EXISTS dossiers_medicaux CASCADE;
DROP TABLE IF EXISTS personnel_medical CASCADE;
DROP TABLE IF EXISTS patients CASCADE;

CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    nir VARCHAR(15) NOT NULL UNIQUE,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    date_naissance DATE NOT NULL,
    adresse TEXT,
    telephone VARCHAR(15),
    email VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE personnel_medical (
    personnel_id SERIAL PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prenom VARCHAR(50) NOT NULL,
    specialite VARCHAR(50) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('medecin', 'infirmier', 'administratif')),
    actif BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE dossiers_medicaux (
    dossier_id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patients(patient_id) ON DELETE CASCADE,
    personnel_id INTEGER NOT NULL REFERENCES personnel_medical(personnel_id) ON DELETE RESTRICT,
    date_consultation DATE NOT NULL,
    diagnostic TEXT NOT NULL,
    traitement TEXT NOT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE prescriptions (
    prescription_id SERIAL PRIMARY KEY,
    dossier_id INTEGER NOT NULL REFERENCES dossiers_medicaux(dossier_id) ON DELETE CASCADE,
    medicament VARCHAR(100) NOT NULL,
    posologie TEXT NOT NULL,
    date_debut DATE NOT NULL,
    date_fin DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


