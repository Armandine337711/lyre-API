-- Revert lyre-API:0000-bdd-initialization from pg

BEGIN;


DROP TABLE IF EXISTS "docket", "desk", "instrument", "member", "piece", "_m2m_meeting_piece", "_m2m_piece_instrument", "place", "post", "meeting_type", "meeting" CASCADE;
DROP DOMAIN IF EXISTS TEXT_ONLY, ALPHANUM, TEXT_MAIL;
DROP EXTENSION IF EXISTS unaccent;

COMMIT;
