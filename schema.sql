CREATE DATABASE govmap_assist;

\c govmap_assist;

-- Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_admin BOOLEAN DEFAULT false;
);

-- Markers table
CREATE TABLE markers (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    latitude DECIMAL(10, 8) NOT NULL,
    longitude DECIMAL(11, 8) NOT NULL,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    category VARCHAR(50),
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Media table
CREATE TABLE media (
    id SERIAL PRIMARY KEY,
    marker_id INTEGER REFERENCES markers(id),
    file_type VARCHAR(10) NOT NULL, -- 'image' or 'video'
    file_path VARCHAR(255) NOT NULL,
    thumbnail_path VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Follow-ups table
CREATE TABLE follow_ups (
    id SERIAL PRIMARY KEY,
    marker_id INTEGER REFERENCES markers(id),
    user_id INTEGER REFERENCES users(id),
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Add tables for likes and comments

-- Likes table
CREATE TABLE likes (
    id SERIAL PRIMARY KEY,
    marker_id INTEGER REFERENCES markers(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(marker_id, user_id)
);

-- Comments table
CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    marker_id INTEGER REFERENCES markers(id) ON DELETE CASCADE,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Admin Responses table for status changes
CREATE TABLE admin_responses (
    id SERIAL PRIMARY KEY,
    marker_id INTEGER REFERENCES markers(id) ON DELETE CASCADE,
    admin_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    old_status VARCHAR(20) NOT NULL,
    new_status VARCHAR(20) NOT NULL,
    cause TEXT NOT NULL,
    resolution_steps TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);