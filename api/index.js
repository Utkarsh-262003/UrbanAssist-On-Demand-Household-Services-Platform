require("dotenv").config();
const express = require("express");
const { Pool } = require("pg");

const app = express();
const PORT = 3000;

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
});

app.get("/healthz", async (req, res) => {
  try {
    await pool.query("SELECT 1");
    res.status(200).send("ok");
  } catch (err) {
    console.error(err);
    res.status(503).send("db down");
  }
});

app.listen(PORT, () => {
  console.log(`API running on port ${PORT}`);
});