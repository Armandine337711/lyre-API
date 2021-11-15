const path = require("path");
require("dotenv").config({
    path: path.join(__dirname, "../../.env"),
});
const { Client } = require("pg");

const desks = require("./datas/desk.json");
const meetings = require("./datas/meeting-type.json");
const dockets = require("./datas/docket.json");

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

    for (const docket of dockets) {
        const result = await client.query(
            `INSERT INTO "docket"("docket") VALUES ($1) RETURNING *`,
            [docket.docket]
        );

        console.log(result.rows[0].id, result.rows[0].docket);
    }
    console.log("dosket inserted");

    await client.end();
})();
