-- dao
CREATE TABLE daos (
    id SERIAL PRIMARY KEY,
    dao_name TEXT NOT NULL,
    dao_short_description TEXT,
    dao_url TEXT UNIQUE NOT NULL,
    governance_id INT, -- constraint maintained from governance table
    tokenomics_id INT, -- constraint maintained from tokenomics table
    design_id INT, -- constraint maintained from design table
    is_draft BOOLEAN,
    is_published BOOLEAN,
    nav_stage INT,
    is_review BOOLEAN
);

-- design
CREATE TABLE dao_themes (
    id SERIAL PRIMARY KEY,
);

ALTER TABLE dao_themes add column theme_name TEXT NOT NULL default 'Paideia'
ALTER TABLE dao_themes add column primary_color TEXT NOT NULL default '#00868F';
ALTER TABLE dao_themes add column secondary_color TEXT NOT NULL default '#FF8219';
ALTER TABLE dao_themes add column dark_primary_color TEXT NOT NULL default '#9FD2DB';
ALTER TABLE dao_themes add column dark_secondary_color TEXT NOT NULL default '#FC9E4F';

CREATE TABLE dao_designs (
    id SERIAL PRIMARY KEY,
    dao_id INT REFERENCES daos(id) ON DELETE CASCADE,
    theme_id INT REFERENCES dao_themes(id),
    logo_url TEXT,
    show_banner BOOLEAN,
    banner_url TEXT,
    show_footer BOOLEAN,
    footer_text TEXT
);

CREATE TABLE footer_social_links (
    id SERIAL PRIMARY KEY,
    design_id INT REFERENCES dao_designs(id) ON DELETE CASCADE,
    social_network TEXT,
    link_url TEXT
);

-- governance
CREATE TABLE governances (
    id SERIAL PRIMARY KEY,
    dao_id INT REFERENCES daos(id) ON DELETE CASCADE,
    is_optimistic BOOLEAN,
    is_quadratic_voting BOOLEAN,
    time_to_challenge__sec INT,
    quorum INT,
    vote_duration__sec INT,
    amount DECIMAL,
    currency TEXT,
    support_needed INT
);

CREATE TABLE governance_whitelist (
    id SERIAL PRIMARY KEY,
    governance_id INT REFERENCES governances(id) ON DELETE CASCADE,
    ergo_address_id INT REFERENCES ergo_addresses(id)
);

-- tokenomics and distributions
CREATE TABLE tokenomics (
    id SERIAL PRIMARY KEY,
    dao_id INT REFERENCES daos(id) ON DELETE CASCADE,
    type TEXT NOT NULL,
    token_id TEXT,
    token_name TEXT,
    token_ticker TEXT,
    token_amount DECIMAL,
    token_image_url TEXT,
    token_remaining DECIMAL,
    is_activated BOOLEAN
);

CREATE TABLE token_holders (
    id SERIAL PRIMARY KEY,
    ergo_address_id INT REFERENCES ergo_addresses(id),
    percentage DECIMAL,
    balance DECIMAL
);

CREATE TABLE tokenomics_token_holders (
    id SERIAL PRIMARY KEY,
    token_holder_id INT REFERENCES token_holders(id) ON DELETE CASCADE,
    tokenomics_id INT REFERENCES tokenomics(id) ON DELETE CASCADE
);

CREATE TABLE distributions (
    id SERIAL PRIMARY KEY,
    tokenomics_id INT REFERENCES tokenomics(id) ON DELETE CASCADE,
    distribution_type TEXT NOT NULL,
    balance DECIMAL,
    percentage DECIMAL
);

CREATE TABLE distribution_token_holders (
    id SERIAL PRIMARY KEY,
    token_holder_id INT REFERENCES token_holders(id) ON DELETE CASCADE,
    distribution_id INT REFERENCES distributions(id) ON DELETE CASCADE
);

CREATE TABLE airdrop_validated_fields (
    id SERIAL PRIMARY KEY,
    distribution_id INT REFERENCES distributions(id) ON DELETE CASCADE,
    value TEXT,
    number INT
);

CREATE TABLE distribution_config (
    id SERIAL PRIMARY KEY,
    distribution_id INT REFERENCES distributions(id) ON DELETE CASCADE,
    property_name TEXT,
    property_value TEXT,
    property_data_type TEXT DEFAULT 'str'
);

-- execute after daos table is created
ALTER TABLE user_details
ADD CONSTRAINT user_details_dao_id_fkey
FOREIGN KEY (dao_id) REFERENCES daos(id) ON DELETE CASCADE;

-- patches
ALTER TABLE daos ADD COLUMN category TEXT;
ALTER TABLE daos ADD COLUMN created_dtz TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP;
