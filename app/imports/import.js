const path = require("path");
require("dotenv").config({
    path: path.join(__dirname, "../../.env"),
});
const { Client } = require("pg");

const desks = require("./datas/desk.json");
const meetings = require("./datas/meeting-type.json");

(async () => {
    const client = new Client({
        connectionString: process.env.DATABASE_URL,
    });
    await client.connect(console.log());

    await client.query(
        `TRUNCATE TABLE "desk", "meeting_type" RESTART IDENTITY CASCADE`
    );

    for (const desk of desks) {
        const result = await client.query(
            `INSERT INTO "desk"("desk") VALUES ($1) RETURNING *`,
            [desk.desk]
        );

        console.log(result.rows[0].id, result.rows[0].desk);
    }
    console.log("desks inserted");

    for (const meeting of meetings) {
        const result = await client.query(
            `INSERT INTO "meeting_type"("entitled") VALUES ($1) RETURNING *`,
            [meeting.entitled]
        );

        console.log(result.rows[0].id, result.rows[0].entitled);
    }
    console.log("meeting_types inserted");

    await client.end();
})();
