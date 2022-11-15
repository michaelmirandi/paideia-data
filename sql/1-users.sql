-- users
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    alias TEXT UNIQUE NOT NULL,
    primary_wallet_address_id INT UNIQUE,
    hashed_password TEXT NOT NULL,
    is_active BOOLEAN DEFAULT true,
    is_superuser BOOLEAN DEFAULT false
);

-- has dao specific user data
CREATE TABLE user_details (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    dao_id INT,
    name TEXT,
    profile_img_url TEXT,
    bio TEXT,
    level INT DEFAULT 0,
    xp INT DEFAULT 0,
    social_links JSON DEFAULT '[]',
    UNIQUE (user_id, dao_id)
);

CREATE TABLE user_followers (
    id SERIAL PRIMARY KEY,
    follower_id INT REFERENCES user_details(id) ON DELETE CASCADE,
    followee_id INT REFERENCES user_details(id) ON DELETE CASCADE
);

CREATE TABLE user_profile_settings (
    id SERIAL PRIMARY KEY,
    user_details_id INT REFERENCES user_details(id) ON DELETE CASCADE,
    settings JSON DEFAULT '{}',
    UNIQUE (user_details_id)
);

CREATE TABLE ergo_addresses (
    id SERIAL PRIMARY KEY,
    user_id INT, -- we keep the record on delete to maintain other dependencies
    address TEXT UNIQUE,
    is_smart_contract BOOLEAN DEFAULT false
);

CREATE TABLE jwt_blacklist (
    id SERIAL PRIMARY KEY,
    token TEXT NOT NULL,
    timestamp TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX ON jwt_blacklist (token);

-- patches
ALTER TABLE users
ADD CONSTRAINT users_primary_wallet_address_id_fkey
FOREIGN KEY (primary_wallet_address_id) REFERENCES ergo_addresses(id);

ALTER TABLE user_details
ADD CONSTRAINT user_details_dao_id_name_key UNIQUE (dao_id, name);
