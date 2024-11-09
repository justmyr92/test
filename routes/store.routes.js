const express = require("express");
const router = express.Router();
const bcrypt = require("bcrypt");
const pool = require("../database/coffeeshop.db");
const jwtAuthorize = require("../middleware/jwt.validator");

router.get("/get/store-locations", jwtAuthorize, async (req, res) => {
    try {
        const query = `SELECT * from store_location`;

        const users = await pool.query(query);
        return res.json(users.rows);
    } catch (error) {
        console.error("Error fetching user data:", error);
        throw error; // Handle error as needed
    }
});

router.post("/add/store-location", jwtAuthorize, async (req, res) => {
    try {
        const { store_name, address, latitude, longitude } = req.body;

        const query = `
            INSERT INTO store_location (store_name, address, latitude, longitude)
            VALUES ($1, $2, $3, $4)
            RETURNING *;
        `;

        const values = [store_name, address, latitude, longitude];

        const result = await pool.query(query, values);

        res.status(200).json({
            message: "Store location added successfully",
            storeLocation: result.rows[0],
        });
    } catch (error) {
        console.error("Error adding store location:", error);
        res.status(500).json({
            error: "An error occurred while adding store location",
        });
    }
});

router.patch("/update/store-location", jwtAuthorize, async (req, res) => {
    try {
        const { id, store_name, address, latitude, longitude } = req.body;
        console.log("Received store_id:", id); // Debugging line

        const query = `
            UPDATE store_location
            SET store_name = $2, address = $3, latitude = $4, longitude = $5
            WHERE store_id = $1
            RETURNING *;
        `;

        const values = [id, store_name, address, latitude, longitude];
        const result = await pool.query(query, values);

        res.status(200).json({
            message: "Store location updated successfully",
            storeLocation: result.rows[0],
        });
    } catch (error) {
        console.error("Error updating store location:", error);
        res.status(500).json({
            error: "An error occurred while updating store location",
        });
    }
});

router.delete(
    "/delete/store-location/:storeId",
    jwtAuthorize,
    async (req, res) => {
        const { storeId } = req.params;

        try {
            const query = `
            DELETE FROM store_location
            WHERE store_id = $1
            RETURNING *;
        `;
            const result = await pool.query(query, [storeId]);

            res.status(200).json({
                message: "Store location deleted successfully",
            });
        } catch (error) {
            console.error("Error deleting store location:", error);
            res.status(500).json({
                error: "An error occurred while deleting the store location",
            });
        }
    }
);

module.exports = router;
