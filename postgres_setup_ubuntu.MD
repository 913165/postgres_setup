
# PostgreSQL Setup Script for Ubuntu

This script installs and configures PostgreSQL on an Ubuntu system, creates a sample database, and a `users` table with some sample data.

---

## Steps

### 1. Update the System Packages
```bash
sudo apt-get update -y
```

### 2. Install PostgreSQL and Contrib Package
```bash
sudo apt-get install -y postgresql postgresql-contrib
```

### 3. Start the PostgreSQL Service
```bash
sudo systemctl enable postgresql
sudo systemctl start postgresql
```

### 4. Switch to PostgreSQL User
```bash
sudo -i -u postgres
```

### 5. Open the PostgreSQL Interactive Terminal (psql)
```bash
psql
```

---

## Database Setup Commands

### 6. Create a New Database
```sql
CREATE DATABASE usersdb;
```

### 7. Create a `users` Table
```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,       -- Store hashed passwords, NOT plain text!
    registration_date TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    role VARCHAR(50) DEFAULT 'user'       -- e.g., 'user', 'admin', 'editor'
);
```

### 8. Insert Sample Data into the `users` Table
```sql
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
```

---

## Notes

- **Hashed Passwords:** Always store hashed passwords, never plaintext passwords.
- **Default Values:** If `role` is not provided, it defaults to `'user'`. If `is_active` is not provided, it defaults to `TRUE`.
- **Sample Data:** The sample data includes users with different roles and `is_active` statuses.

---

## to connect from outside network (change your version instead of 14)

/etc/postgresql/14/main/pg_hba.conf
insert below line at last 

```bash
hostssl all postgres 0.0.0.0/0 md5
```

/etc/postgresql/14/main/postgresql.conf(change your version instead of 14)
```bash
listen_addresses = '*'
```

and then restart services using below command

```bash
 sudo systemctl restart  postgresql
```

## Final Steps

Exit the `psql` session and return to your normal user:
```bash
\q
exit
```

---

Run this script step-by-step to set up PostgreSQL on your Ubuntu machine and initialize the database with sample data.

