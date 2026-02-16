-- 3. Chiffrement des données sensibles

CREATE EXTENSION IF NOT EXISTS pgcrypto;

Create TABLE configuration_securite(
	cle_config VARCHAR(50) PRIMARY KEY,
	valeur TEXT NOT NULL,
	description TEXT,
	date_mise_a_jour TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO configuration_securite (cle_config, valeur, description)
VALUES ('master_key', 'ma_master_key', 'Master key pour générer les clés des patients')
ON CONFLICT (cle_config) DO NOTHING;

ALTER TABLE patients ALTER COLUMN nir TYPE BYTEA USING pgp_sym_encrypt(nir, get_master_key());

CREATE OR REPLACE FUNCTION get_master_key()
RETURNS TEXT AS $$
BEGIN
    RETURN (SELECT valeur FROM configuration_securite WHERE cle_config = 'master_key');
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE FUNCTION generer_cle_patient(p_patient_id INTEGER)
RETURNS TEXT AS $$
DECLARE
    salt CONSTANT TEXT := 'salt_hopital_secure';
BEGIN
    RETURN encode(digest(
        get_master_key() || p_patient_id::TEXT || salt,
        'sha256'
    ), 'hex');
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION chiffrer_nir(nir TEXT, key TEXT)
RETURNS BYTEA AS $$
BEGIN
    RETURN pgp_sym_encrypt(nir, key);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION chiffrer_nir_trigger()
RETURNS TRIGGER AS $$
BEGIN
    NEW.nir = pgp_sym_encrypt(NEW.nir, generer_cle_patient(NEW.patient_id));
    NEW.nir_hash = encode(digest(NEW.nir, 'sha256'), 'hex');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_chiffrer_nir
BEFORE INSERT ON patients
FOR EACH ROW EXECUTE FUNCTION chiffrer_nir_trigger();

CREATE OR REPLACE FUNCTION dechiffrer_nir(nir_chiffre BYTEA, key TEXT)
RETURNS TEXT AS $$
BEGIN
    RETURN pgp_sym_decrypt(nir_chiffre, key);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION dechiffrer_donnee_patient(donnee_chiffree BYTEA, key TEXT)
RETURNS TEXT AS $$
BEGIN
    RETURN pgp_sym_decrypt(donnee_chiffree, key);
END;
$$ LANGUAGE plpgsql;