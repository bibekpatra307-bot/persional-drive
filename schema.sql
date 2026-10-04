-- ============================================================
-- PRIVATE CLOUD - POSTGRESQL & SUPABASE DATABASE SCHEMA
-- ============================================================

-- 1. Settings Table (Store master password hash, allowed folders, and server configs)
CREATE TABLE IF NOT EXISTS settings (
    key VARCHAR(64) PRIMARY KEY,
    value JSONB NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Sessions Table (Store authenticated sessions with expiration)
CREATE TABLE IF NOT EXISTS sessions (
    id VARCHAR(128) PRIMARY KEY,
    ip VARCHAR(64),
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL
);

-- 3. Drive Connections Table (Store admin authorized Google Drive connection state)
CREATE TABLE IF NOT EXISTS drive_connections (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    access_token TEXT,
    refresh_token TEXT,
    token_expiry TIMESTAMP WITH TIME ZONE,
    connected_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE
);

-- 4. Drive Folders (Store administrator-selected permitted folders)
CREATE TABLE IF NOT EXISTS drive_folders (
    folder_id VARCHAR(128) PRIMARY KEY,
    folder_name VARCHAR(255) NOT NULL,
    is_selected BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. Favorites Table (Starred files)
CREATE TABLE IF NOT EXISTS favorites (
    file_id VARCHAR(128) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    mime_type VARCHAR(128) NOT NULL,
    thumbnail_link TEXT,
    web_view_link TEXT,
    size BIGINT DEFAULT 0,
    modified_time TIMESTAMP WITH TIME ZONE,
    added_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 6. Recent Files Table (Track opened/streamed files)
CREATE TABLE IF NOT EXISTS recent_files (
    file_id VARCHAR(128) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    mime_type VARCHAR(128) NOT NULL,
    thumbnail_link TEXT,
    web_view_link TEXT,
    size BIGINT DEFAULT 0,
    opened_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 7. Audit Logs Table (Security and access audit history)
CREATE TABLE IF NOT EXISTS audit_logs (
    id SERIAL PRIMARY KEY,
    event VARCHAR(64) NOT NULL,
    ip VARCHAR(64),
    details TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for high performance
CREATE INDEX IF NOT EXISTS idx_sessions_expires_at ON sessions(expires_at);
CREATE INDEX IF NOT EXISTS idx_favorites_added_at ON favorites(added_at DESC);
CREATE INDEX IF NOT EXISTS idx_recent_files_opened_at ON recent_files(opened_at DESC);
CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at ON audit_logs(created_at DESC);
