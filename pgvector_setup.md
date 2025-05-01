# Installing PostgreSQL with pgvector on Ubuntu

This guide provides a step-by-step process for installing PostgreSQL with the pgvector extension on Ubuntu.  pgvector enables you to store and perform similarity searches on vector embeddings, which is useful for applications like semantic search, recommendation systems, and more.

## Prerequisites

* Ubuntu server

## Installation

1.  **Install PostgreSQL common packages:**

    ```bash
    sudo apt install -y postgresql-common
    ```
    * This command installs the necessary infrastructure and support files for managing PostgreSQL installations.

2.  **Add the PostgreSQL apt repository:**

    ```bash
    sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
    ```

    * This script adds the official PostgreSQL apt repository to your system's software sources, ensuring you get the latest versions.

3.  **Install PostgreSQL and pgvector:**

    ```bash
    sudo apt install postgresql-17-pgvector
    ```

    * This command installs PostgreSQL 17 and the pgvector extension.  Adjust the PostgreSQL version number (e.g., `postgresql-16-pgvector`) as needed.

## Configuration

1.  **Access PostgreSQL:**

    ```bash
    sudo -u postgres psql
    ```

    * This command switches to the `postgres` user and opens the PostgreSQL interactive terminal.

2.  **Enable extensions:**

    ```sql
    CREATE EXTENSION IF NOT EXISTS vector;
    CREATE EXTENSION IF NOT EXISTS hstore;
    CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
    ```

    * `vector`: Enables the pgvector extension for storing and querying vector embeddings.
    * `hstore`: Enables the `hstore` extension, which allows storing key-value pairs within a single PostgreSQL value.  Useful for metadata.
    * `uuid-ossp`: Enables the generation of universally unique identifiers (UUIDs), which can be used as primary keys.

3.  **Create a table to store vectors:**

    ```sql
    CREATE TABLE IF NOT EXISTS vector_store (
        id uuid DEFAULT uuid_generate_v4() PRIMARY KEY,
        content text,
        metadata json,
        embedding vector(1536)
    );
    ```

    * `id`: A unique identifier for each vector, automatically generated using `uuid_generate_v4()`.
    * `content`:  A text field to store the original content (e.g., the text that was embedded).
    * `metadata`: A JSON field to store any additional information about the vector.
    * `embedding`: A `vector` column to store the vector embedding.  Here, the dimension is set to 1536, which is common for embeddings from models like OpenAI's `text-embedding-ada-002`.  Adjust this as needed for your embedding model.

4.  **Create an index for efficient similarity search:**

    ```sql
    CREATE INDEX ON vector_store USING HNSW (embedding vector_cosine_ops);
    ```

    * This creates an index on the `embedding` column using the Hierarchical Navigable Small World (HNSW) algorithm.
    * `HNSW` is an efficient algorithm for approximate nearest neighbor search, which is crucial for fast similarity lookups.
    * `vector_cosine_ops` specifies that the cosine distance should be used for measuring similarity.  Other options include `vector_l2_ops` for Euclidean distance and `vector_inner_product_ops` for inner product.

5.  **Allow remote connections (Optional - for development/testing only):**

    * **Edit `pg_hba.conf`:**

        ```bash
        sudo nano /etc/postgresql/17/main/pg_hba.conf
        ```

        * Add the following line to the end of the file:

            ```
            host    all             postgres            0.0.0.0/0            trust
            ```
            **Warning:** Using `trust` authentication is insecure and should **never** be used in a production environment.  It allows any user to connect without a password.  For production, use a more secure authentication method (e.g., `md5`).  The file path `/etc/postgresql/17/main/pg_hba.conf` might be different based on your PostgreSQL version.

    * **Edit `postgresql.conf`:**

        ```bash
        sudo nano /etc/postgresql/17/main/postgresql.conf
        ```

        * Find the `listen_addresses` line and change it to:

            ```
            listen_addresses = '*'
            ```

            This tells PostgreSQL to listen for connections on all network interfaces.  The file path `/etc/postgresql/17/main/postgresql.conf` might be different based on your PostgreSQL version.

6.  **Restart PostgreSQL:**

    ```bash
    sudo systemctl restart postgresql
    ```

    * This command restarts the PostgreSQL service to apply the changes made to the configuration files.
