const express = require("express");
const router = express.Router();
const pool = require("../database/coffeeshop.db");
const jwtAuthorize = require("../middleware/jwt.validator");
const cloudinary = require("../utils/cloudinary");
const multer = require("multer");

const storage = multer.diskStorage({
    filename: function (req, file, cb) {
        cb(null, file.originalname);
    },
});

const upload = multer({ storage: storage });

// Route to upload a promotion
router.post(
    "/upload-promo",
    jwtAuthorize,
    upload.single("promoImage"),
    async (req, res) => {
        if (!req.file) {
            return res.status(400).json({ error: "No image uploaded" });
        }

        const { promoTitle, promoDescription } = req.body;
        const promoImage = req.file.path; // Get the image path

        console.log(promoTitle);
        if (!promoTitle || !promoDescription) {
            return res.status(400).json({
                error: "Promotion title and description are required",
            });
        }

        try {
            // Insert the promotion data into the database (adjust the table name and columns as needed)
            cloudinary.uploader.upload(
                req.file.path,
                async function (err, result) {
                    if (err) {
                        console.log(err);
                        return res.status(500).json({
                            success: false,
                            message: "Error",
                        });
                    } else {
                        const results = await pool.query(
                            "INSERT INTO promotions (promo_title, promo_description, promo_image) VALUES ($1, $2, $3) RETURNING *",
                            [promoTitle, promoDescription, result.url]
                        );

                        // Respond with the inserted data
                        res.status(201).json({
                            message: "Promotion uploaded successfully",
                            promotion: results.rows[0],
                        });
                    }
                }
            );
        } catch (err) {
            console.error(err);
            res.status(500).json({ error: "Failed to upload promotion" });
        }
    }
);

// Route to get all promotions
router.get("/get-promos", async (req, res) => {
    try {
        // Query to fetch all promotions from the database
        const result = await pool.query("SELECT * FROM promotions");

        // Respond with the promotions data
        res.status(200).json(result.rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Failed to fetch promotions" });
    }
});

router.patch(
    "/update-promo/:id",
    upload.single("promoImage"), // Multer is configured for 'promoImage'
    async (req, res) => {
        const { id } = req.params;
        const { promoTitle, promoDescription } = req.body;
        let promoImage = req.file ? req.file.path : null;
        console.log(req.file);
        if (!promoTitle || !promoDescription) {
            return res.status(400).json({
                error: "Promotion title and description are required",
            });
        }

        try {
            // Check if the promo exists
            const promoCheck = await pool.query(
                "SELECT * FROM promotions WHERE promo_id = $1",
                [id]
            );

            if (promoCheck.rows.length === 0) {
                return res.status(404).json({ error: "Promotion not found" });
            }
            cloudinary.uploader.upload(
                req.file.path,
                async function (err, result) {
                    if (err) {
                        console.log(err);
                        return res.status(500).json({
                            success: false,
                            message: "Error",
                        });
                    } else {
                        // Update the promotion data
                        const query = `
                UPDATE promotions 
                SET 
                    promo_title = $1, 
                    promo_description = $2, 
                    promo_image = COALESCE($3, promo_image)
                WHERE promo_id = $4 
                RETURNING *`;

                        const values = [
                            promoTitle,
                            promoDescription,
                            result.url,
                            id,
                        ];
                        const results = await pool.query(query, values);

                        res.status(200).json({
                            message: "Promotion updated successfully",
                            promotion: results.rows[0],
                        });
                    }
                }
            );
        } catch (err) {
            console.error(err);
            res.status(500).json({ error: "Failed to update promotion" });
        }
    }
);

// Route to delete a promotion
router.delete("/delete-promo/:id", async (req, res) => {
    const { id } = req.params; // Get the promo ID from the URL

    try {
        // Check if the promo exists before trying to delete
        const promoCheck = await pool.query(
            "SELECT * FROM promotions WHERE promo_id = $1",
            [id]
        );

        if (promoCheck.rows.length === 0) {
            return res.status(404).json({ error: "Promotion not found" });
        }

        // Delete the promo from the database
        const result = await pool.query(
            "DELETE FROM promotions WHERE promo_id = $1 RETURNING *",
            [id]
        );

        // If the promo doesn't exist, no rows will be deleted
        if (result.rowCount === 0) {
            return res
                .status(404)
                .json({ error: "Failed to delete promotion" });
        }

        // Successfully deleted
        res.status(200).json({ message: "Promotion deleted successfully" });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: "Failed to delete promotion" });
    }
});

module.exports = router;
