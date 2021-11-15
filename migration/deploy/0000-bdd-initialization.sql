-- Deploy lyre-API:0000-bdd-initialization to pg

BEGIN;
-------------------------------
-- EXTENTION & DOMAIN
-------------------------------

DROP EXTENSION IF EXISTS unaccent;

CREATE EXTENSION unaccent;

CREATE DOMAIN TEXT_ONLY AS TEXT CHECK(unaccent(VALUE) ~ '^[A-Za-z \-]+$');
CREATE DOMAIN ALPHANUM AS TEXT CHECK(unaccent(VALUE) ~ '^[A-Za-z\ \-\#\d]+$');
CREATE DOMAIN TEXT_MAIL AS TEXT CHECK(VALUE ~ '(^[a-z\d\.\-\_]+)@{1}([a-z\d\.\-]{2,})[.]([a-z]{2,5})$');
-- create domain text_pwd

-------------------------------
-- TABLES
-------------------------------

DROP TABLE IF EXISTS "docket", "desk", "instrument", "member", "piece", "_m2m_meeting_piece", "_m2m_piece_instrument", "place", "post", "meeting_type", "meeting" CASCADE;

--rôle
CREATE TABLE IF NOT EXISTS "docket"(
"id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
"docket" TEXT_ONLY NOT NULL
);

--pupitre
CREATE TABLE IF NOT EXISTS "desk"(
"id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
"desk" TEXT_ONLY NOT NULL
);

--liste des instruments 
CREATE TABLE IF NOT EXISTS "instrument"(
"id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
"entitled" ALPHANUM NOT NULL,
"desk_id" INT NOT NULL REFERENCES "desk"("id")
);

--list des utilisateurs du site
CREATE TABLE IF NOT EXISTS "member"(
"id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
"firstname" TEXT_ONLY NOT NULL,
"lastname" TEXT_ONLY NOT NULL,
"email"TEXT_MAIL NOT NULL UNIQUE,
"password" TEXT NOT NULL,
"desk_id" INT REFERENCES "desk"("id"),
"last_connection" TIMESTAMPTZ DEFAULT NOW(),
"docket_id" INT NOT NULL REFERENCES "docket"("id"),
"hide" BOOLEAN DEFAULT false
);

--list des morceaux
CREATE TABLE IF NOT EXISTS "piece"(
"id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
"title" ALPHANUM NOT NULL UNIQUE,
"author" TEXT_ONLY,
"online" BOOLEAN DEFAULT true
);

--sheet
CREATE TABLE IF NOT EXISTS "_m2m_piece_instrument"(
"id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
"piece_id" INT NOT NULL REFERENCES "piece"("id"),
"instrument_id" INT NOT NULL REFERENCES "instrument"("id"),
"link" TEXT NOT NULL
);
-- emplacements dans le site
CREATE TABLE IF NOT EXISTS "place"(
"id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
"place" TEXT_ONLY NOT NULL
);

CREATE TABLE IF NOT EXISTS "post"(
"id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
"title" TEXT NOT NULL,
"content" TEXT NOT NULL,
"place_id" INT NOT NULL REFERENCES "place"("id"),
"online" BOOLEAN,
"publication_date" TIMESTAMPTZ
);

--concert répétition défilé repas
CREATE TABLE IF NOT EXISTS "meeting_type"(
"id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
"entitled" TEXT NOT NULL UNIQUE
);

--liste des rencontres
CREATE TABLE IF NOT EXISTS "meeting"(
"id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
"meeting_date" TIMESTAMPTZ NOT NULL,
"location" TEXT NOT NULL,
"meeting_type_id" INT NOT NULL REFERENCES "meeting_type"("id")
);

-- concert's program
CREATE TABLE IF NOT EXISTS "_m2m_meeting_piece"(
"id" INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
"meeting_id" INT NOT NULL REFERENCES "meeting"("id"),
"piece_id" INT NOT NULL REFERENCES "piece"("id")
);


COMMIT;
