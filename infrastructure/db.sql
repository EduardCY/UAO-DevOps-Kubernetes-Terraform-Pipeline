-- Database initialization script for PostgreSQL
-- This script creates the users table for the CRUD application

-- Drop table if exists (for clean setup)
DROP TABLE IF EXISTS users;

-- Create users table
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index on name for faster searches
CREATE INDEX idx_users_name ON users(name);

-- Insert sample data for testing
INSERT INTO users (name) VALUES
  ('John Doe'),
  ('Jane Smith'),
  ('Bob Johnson'),
  ('Alice Williams'),
  ('Charlie Brown');

-- Grant permissions (if needed)
-- GRANT ALL PRIVILEGES ON TABLE users TO your_user;
-- GRANT USAGE, SELECT ON SEQUENCE users_id_seq TO your_user;
