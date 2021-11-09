-- Revert lyre-API:0010-add-update-functions from pg

BEGIN;

DROP FUNCTION IF EXISTS "desk_update", "instrument_update", "member_update", "last_connection_update", "piece_update", "_m2m_piece_instrument", "place_update", "post_update", "meeting_type_update", "meeting_update", "_m2m_meeting_piece_update";
DROP FUNCTION IF EXISTS "desk_add", "instrument_add", "member_add", "piece_add", "_m2m_piece_instrument", "place_add", "post_add", "meeting_type_add", "meeting_add", "_m2m_meeting_piece_add";

COMMIT;
