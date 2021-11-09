-- Deploy lyre-API:0010-add-update-functions to pg

BEGIN;

-------------------------------
-- ADD FUNCTIONS
-------------------------------

DROP FUNCTION IF EXISTS "desk_add", "instrument_add", "member_add", "piece_add", "_m2m_piece_instrument", "place_add", "post_add", "meeting_type_add", "meeting_add", "_m2m_meeting_piece_add";

CREATE FUNCTION "desk_add"(newDatas json) RETURNS SETOF "desk" AS
$$
INSERT INTO "desk"("desk") VALUES (
newDatas ->> 'desk'
) RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "instrument_add"(newDatas json) RETURNS SETOF "instrument" AS
$$
INSERT INTO "instrument"("entitled", "desk_id") VALUES (
newDatas ->> 'entitled',
(newDatas ->> 'desk_id')::int
) RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "member_add"(newDatas json) RETURNS SETOF "member" AS
$$
INSERT INTO "member"("firstname", "lastname", "email", "password", "desk_id") VALUES (
newDatas ->> 'firstname',
newDatas ->> 'lastname',
newDatas ->> 'email',
newDatas ->> 'password',
(newDatas ->> 'desk_id')::int
) RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "piece_add"(newDatas json) RETURNS SETOF "piece" AS
$$
INSERT INTO "piece"("title", "author") VALUES (
newDatas ->> 'title',
newDatas ->> 'author'
) RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "_m2m_piece_instrument_add"(newDatas json) RETURNS SETOF "_m2m_piece_instrument" AS
$$
INSERT INTO "_m2m_piece_instrument"("piece_id", "instrument_id", "link") VALUES (
(newDatas ->> 'piece_id')::int,
(newDatas ->> 'instrument_id')::int,
newDatas ->> 'link'
) RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "place_add"(newDatas json) RETURNS SETOF "place" AS
$$
INSERT INTO "place"("place") VALUES (
newDatas->> 'place'
) RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "post_add"(newDatas json) RETURNS SETOF "post" AS
$$
INSERT INTO "post"("title", "content", "place_id", "online")VALUES (
    newDatas->>'title',
    newDatas ->>'content',
    (newDatas ->> 'place_id')::int,
    (newDatas ->> 'online')::boolean
) RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "meeting_type_add"(newDatas json) RETURNS SETOF "meeting_type" AS
$$
INSERT INTO "meeting_type"("entitled") VALUES (
    newDatas ->> 'entitled'
) RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "meeting_add"(newDatas json) RETURNS SETOF "meeting" AS
$$
INSERT INTO "meeting"("meeting_date", "location", "meeting_type_id") VALUES (
(newDatas ->> 'meeting_date')::timestamptz,
newDatas ->> 'location',
(newDatas ->> 'meeting_type_id')::int
) RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "_m2m_meeting_piece_add"(newDatas json) RETURNS SETOF "_m2m_meeting_piece" AS
$$
INSERT INTO "_m2m_meeting_piece"("meeting_id", "piece_id") VALUES (
(newDatas ->> 'meeting_id')::int,
(newDatas ->> 'piece_id')::int
) RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

-------------------------------
-- UPDATE FUNCTIONS
-------------------------------
CREATE FUNCTION "desk_update"(updatedDatas json) RETURNS SETOF "desk" AS
$$
UPDATE "desk" SET
"desk" = updatedDatas --> 'desk,
WHERE "id" = (updatedDatas ->> 'id')::int
 RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "instrument_update"(updatedDatas json) RETURNS SETOF "instrument" AS
$$
UPDATE "instrument" SET
"entitled" = updatedDatas ->> 'entitled',
"desk_id" = (updatedDatas ->>'desk_id')::int
WHERE "id" = (updatedDatas ->> 'id')::int
 RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "member_update"(updatedDatas json) RETURNS SETOF "member" AS
$$
UPDATE "member" SET
"firstname" = updatedDatas ->> 'firstname',
"lastname" = updatedDatas ->> 'lastname',
"email" = updatedDatas ->> 'email',
"password" = updatedDatas ->> 'password',
"desk_id" = (updatedDatas ->> 'desk_id')::int,
"hide" = (updatedDatas ->> 'hide')::boolean
WHERE "id" = (updatedDatas ->> 'id')::int
 RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "last_connection_update"(updatedDatas json) RETURNS SETOF "member" AS
$$
UPDATE "member" SET
"last_connection" = (updatedDatas ->> 'last_connection')::timestamptz
WHERE "id" = (updatedDatas ->> 'id')::int
 RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "piece_update"(updatedDatas json) RETURNS SETOF "piece" AS
$$
UPDATE "piece" SET
"title" = updatedDatas ->> 'title',
"author" = updatedDatas ->> 'author',
"online" = (updatedDatas ->> 'online')::boolean
WHERE "id" = (updatedDatas ->> 'id')::int
 RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "_m2m_piece_instrument_update"(updatedDatas json) RETURNS SETOF "_m2m_piece_instrument" AS
$$
UPDATE "_m2m_piece_instrument" SET
"piece_id" = (updatedDatas ->> 'piece_id')::int,
"instrument_id" = (updatedDatas ->> 'instrument_id')::int,
"link" = updatedDatas ->> 'link'
WHERE "id" = (updatedDatas ->> 'id')::int
 RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "place_update"(updatedDatas json) RETURNS SETOF "place" AS
$$
UPDATE "place" SET
"place" = updatedDatas ->> 'place'
WHERE "id" = (updatedDatas ->> 'id')::int
 RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "post_update"(updatedDatas json) RETURNS SETOF "post" AS
$$
UPDATE "post" SET
"title" = updatedDatas ->> 'title',
"content"= updatedDatas->> 'content',
"place_id" =(updatedDatas ->> 'place_id')::int,
"online" = (updatedDatas ->> 'online')::boolean
WHERE "id" = (updatedDatas ->> 'id')::int
 RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "meeting_type_update"(updatedDatas json) RETURNS SETOF "meeting_type" AS
$$
UPDATE "meeting_type" SET
"entitled" = updatedDatas ->> 'entitled'
WHERE "id" = (updatedDatas ->> 'id')::int
 RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "meeting_update"(updatedDatas json) RETURNS SETOF "meeting" AS
$$
UPDATE "meeting" SET
"meeting_date" = (updatedDatas ->> 'meeting_date')::timestamptz,
"location" = updatedDatas->> 'location',
"meeting_type_id" = (updatedDatas ->> 'meeting_type_id')::int
WHERE "id" = (updatedDatas ->> 'id')::int
 RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

CREATE FUNCTION "_m2m_meeting_piece_update"(updatedDatas json) RETURNS SETOF "_m2m_meeting_piece" AS
$$
UPDATE "_m2m_meeting_piece" SET
"meeting_id" = (updatedDatas ->> 'meeting_id')::int,
"piece_id" = (updatedDatas ->> 'piece_id')::int
WHERE "id" = (updatedDatas ->> 'id')::int
 RETURNING *;
$$
LANGUAGE sql VOLATILE STRICT;

COMMIT;
