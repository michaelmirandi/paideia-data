-- blogs
CREATE TABLE blogs (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    link TEXT NOT NULL UNIQUE,
    img_url TEXT,
    description TEXT,
    content TEXT,
    category TEXT,
    additional_details JSON DEFAULT '{}',
    date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- faq section
CREATE TABLE faqs (
    id SERIAL PRIMARY KEY,
    question TEXT NOT NULL,
    answer TEXT,
    tags JSON DEFAULT '[]'
);

-- quotes
CREATE TABLE quotes (
    id SERIAL PRIMARY KEY,
    quote TEXT NOT NULL,
    author TEXT,
    show BOOLEAN DEFAULT true
);

-- sponsered/highlighted projects section
CREATE TABLE project_highlights (
    id SERIAL PRIMARY KEY,
    dao_id INT NOT NULL REFERENCES daos(id) ON DELETE CASCADE
);
