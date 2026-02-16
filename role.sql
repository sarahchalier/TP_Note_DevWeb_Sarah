-- 4. Gestion des accès par rôles

CREATE ROLE role_medecin;
CREATE ROLE role_infirmier;
CREATE ROLE role_administratif;
CREATE ROLE role_patient;

CREATE VIEW vue_administratif AS
SELECT patient_id, nom, prenom, date_naissance, adresse, telephone, email
FROM patients;

CREATE VIEW vue_infirmier AS
SELECT dossier_id, patient_id, date_consultation, diagnostic, traitement
FROM dossiers_medicaux;

CREATE VIEW vue_patient AS
SELECT d.dossier_id, d.date_consultation, d.diagnostic, d.traitement, d.notes, p.nom AS medecin_nom, p.prenom AS medecin_prenom
FROM dossiers_medicaux d
JOIN patients pa ON d.patient_id = pa.patient_id
JOIN personnel_medical p ON d.personnel_id = p.personnel_id
WHERE pa.email = current_user;

ALTER TABLE dossiers_medicaux ENABLE ROW LEVEL SECURITY;

CREATE POLICY donnee_patient ON dossiers_medicaux
FOR SELECT
USING (patient_id = (SELECT patient_id FROM patients WHERE nom = current_user));

CREATE POLICY personnel_medical ON dossiers_medicaux
FOR SELECT
USING (personnel_id = (SELECT personnel_id FROM personnel_medical WHERE nom = current_user));

GRANT SELECT, INSERT, UPDATE, DELETE ON dossiers_medicaux TO role_medecin;

GRANT SELECT ON patients TO role_medecin;

GRANT SELECT ON prescriptions TO role_medecin;

GRANT SELECT ON vue_infirmier TO role_infirmier;

GRANT SELECT ON vue_administratif TO role_administratif;

GRANT SELECT ON vue_patient TO role_patient;
