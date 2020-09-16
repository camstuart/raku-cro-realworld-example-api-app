--------------------------------------------------------------------------------
BEGIN;
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Database Setup: Extensions & Functions
--------------------------------------------------------------------------------
CREATE EXTENSION IF NOT EXISTS CITEXT;

CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;
--------------------------------------------------------------------------------
-- Domain: Users, AKA Authors
--------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
    id          SERIAL          PRIMARY KEY,
    email       CITEXT          NOT NULL,
    username    VARCHAR(20)     NOT NULL,
    password    VARCHAR(50)     NOT NULL,
    bio         TEXT            NOT NULL,
    image       TEXT            NOT NULL,
    created_at  TIMESTAMPTZ     NOT NULL    DEFAULT NOW(),
    updated_at  TIMESTAMPTZ     NOT NULL    DEFAULT NOW(),
    UNIQUE      (email, username)
);

DROP TRIGGER IF EXISTS users_set_timestamp ON users;

CREATE TRIGGER users_set_timestamp
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();
--------------------------------------------------------------------------------
-- Domain: Articles
--------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS articles (
    id              SERIAL          PRIMARY KEY,
    user_id         INTEGER         REFERENCES  users (id),
    slug            TEXT            NOT NULL,
    title           CITEXT          NOT NULL,
    description     CITEXT          NOT NULL,
    body            CITEXT          NOT NULL,
    tags            CITEXT[],
    favorited       BOOLEAN         NOT NULL    DEFAULT false,
    favorite_count  INTEGER         NOT NULL    DEFAULT 0,
    created_at      TIMESTAMPTZ     NOT NULL    DEFAULT NOW(),
    updated_at      TIMESTAMPTZ     NOT NULL    DEFAULT NOW(),
    UNIQUE          (slug)
);

DROP TRIGGER IF EXISTS articles_set_timestamp ON articles;

CREATE TRIGGER articles_set_timestamp
BEFORE UPDATE ON articles
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();
--------------------------------------------------------------------------------
-- Domain: Tags (Belonging to Articles)
--------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tags (
    id              SERIAL          PRIMARY KEY,
    title           CITEXT          NOT NULL,
    created_at      TIMESTAMPTZ     NOT NULL    DEFAULT NOW(),
    updated_at      TIMESTAMPTZ     NOT NULL    DEFAULT NOW(),
    UNIQUE          (title)
);

DROP TRIGGER IF EXISTS tags_set_timestamp ON articles;

CREATE TRIGGER tags_set_timestamp
BEFORE UPDATE ON tags
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();
--------------------------------------------------------------------------------
-- Domain: Comments
--------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS comments (
    id              SERIAL          PRIMARY KEY,
    user_id         INTEGER         REFERENCES  users (id),
    body            CITEXT          NOT NULL,
    created_at      TIMESTAMPTZ     NOT NULL    DEFAULT NOW(),
    updated_at      TIMESTAMPTZ     NOT NULL    DEFAULT NOW()
);

DROP TRIGGER IF EXISTS comments_set_timestamp ON comments;

CREATE TRIGGER comments_set_timestamp
BEFORE UPDATE ON comments
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

--------------------------------------------------------------------------------
COMMIT;
--------------------------------------------------------------------------------