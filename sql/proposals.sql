-- proposals
CREATE TABLE proposals (
    id SERIAL PRIMARY KEY,
    dao_id INT REFERENCES daos(id) ON DELETE CASCADE,
    user_id INT, -- keeps the proposal as anonymous
    name TEXT NOT NULL,
    image_url TEXT,
    category TEXT,
    content TEXT,
    voting_system TEXT,
    actions JSON DEFAULT '{}',
    tags JSON DEFAULT '{}',
    attachments JSON DEFAULT '{}',
    date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_proposal BOOLEAN DEFAULT false
);

CREATE TABLE proposal_addendums (
    id SERIAL PRIMARY KEY,
    proposal_id INT REFERENCES proposals(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    content TEXT,
    date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE proposal_comments (
    id SERIAL PRIMARY KEY,
    proposal_id INT REFERENCES proposals(id) ON DELETE CASCADE,
    user_id INT, -- keeps the comment as anonymous
    comment TEXT,
    parent INT,
    date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE proposal_likes (
    id SERIAL PRIMARY KEY,
    proposal_id INT REFERENCES proposals(id) ON DELETE CASCADE,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    liked BOOLEAN -- true if liked, false if disliked
);

CREATE TABLE proposal_followers (
    id SERIAL PRIMARY KEY,
    proposal_id INT REFERENCES proposals(id) ON DELETE CASCADE,
    user_id INT REFERENCES users(id) ON DELETE CASCADE
);

CREATE TABLE proposal_references (
    id SERIAL PRIMARY KEY,
    referred_proposal_id REFERENCES proposals(id) ON DELETE CASCADE,
    referring_proposal_id REFERENCES proposals(id) ON DELETE CASCADE
);
