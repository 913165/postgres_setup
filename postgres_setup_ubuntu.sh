sudo apt update

sudo apt install postgresql postgresql-contrib

sudo systemctl start postgresql.service

sudo -i -u postgres

psql

createdb usersdb


CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,       -- Store hashed passwords, NOT plain text!
    registration_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    role VARCHAR(50) DEFAULT 'user'       -- e.g., 'user', 'admin', 'editor'
);

--  Insert sample data into the 'users' table.
INSERT INTO users (username, email, password, role)
VALUES ('john_doe', 'john.doe@example.com', 'hashed_password_1', 'user');

INSERT INTO users (username, email, password, role)
VALUES ('jane_smith', 'jane.smith@sample.net', 'hashed_password_2', 'editor');

INSERT INTO users (username, email, password)
VALUES ('peter_pan', 'peter.pan@neverland.org', 'hashed_password_3');  -- Uses default role 'user'

INSERT INTO users (username, email, password, is_active)
VALUES ('alice_wonder', 'alice@wonderland.co.uk', 'hashed_password_4', TRUE);

INSERT INTO users (username, email, password, is_active, role)
VALUES ('bob_builder', 'bob@canwefixtit.com', 'hashed_password_5', FALSE, 'admin');

