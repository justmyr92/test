const express = require("express");
const router = express.Router();
const pool = require("../database/coffeeshop.db");
const jwtAuthorize = require("../middleware/jwt.validator");
const multer = require("multer");
const path = require("path");
const cloudinary = require("../utils/cloudinary");

const storage = multer.diskStorage({
    filename: function (req, file, cb) {
        cb(null, file.originalname);
    },
});

const upload = multer({ storage: storage });

router.get("/get/products", jwtAuthorize, async (req, res) => {
    try {
        const query = `SELECT * FROM products INNER JOIN categories on categories.category_id = products.category_id`;
        const productswithcategories = await pool.query(query);
        return res.json(productswithcategories.rows);
    } catch (error) {
        console.error(error);
    }
});

router.get("/get/products-by-type/:type", async (req, res) => {
    try {
        const { type } = req.params;
        const query = `SELECT * FROM products INNER JOIN categories on categories.category_id = products.category_id where products.product_type = $1`;
        const productswithcategories = await pool.query(query, [type]);
        return res.json(productswithcategories.rows);
    } catch (error) {
        console.error(error);
    }
});

router.get("/get/categories", jwtAuthorize, async (req, res) => {
    try {
        const query = `SELECT * FROM categories`;
        const categories = await pool.query(query);
        return res.json(categories.rows);
    } catch (error) {
        console.error(error);
    }
});

// router.post("/add/product", jwtAuthorize, async (req, res) => {
//     try {
//         const { product_name, product_price, category_id, product_image } =
//             req.body;

//         // Insert query for adding a new product
//         const query = `
//             INSERT INTO products (product_name, product_price, category_id, product_image)
//             VALUES ($1, $2, $3, $4)
//             RETURNING *;
//         `;

//         // Execute query with values from the request body
//         const newProduct = await pool.query(query, [
//             product_name,
//             product_price,
//             category_id || 1, // Use category_id from body, default to 1 if not provided
//             product_image,
//         ]);

//         return res.json(newProduct.rows[0]); // Return the inserted product
//     } catch (error) {
//         console.error("Error adding product:", error);
//         res.status(500).json({ message: "Error adding product" });
//     }
// });

router.post(
    "/add/product",
    jwtAuthorize,
    upload.single("product_image"),
    async (req, res) => {
        try {
            const { product_name, product_price, category_id } = req.body;
            const product_image = req.file ? req.file.path : null; // Get the image path from the uploaded file
            console.log(category_id);
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
                        // SQL query to insert product into the database
                        const query = `
            INSERT INTO products (product_name, product_price, category_id, product_image)
            VALUES ($1, $2, $3, $4)
            RETURNING *;
        `;

                        // Execute the query to insert the product
                        const newProduct = await pool.query(query, [
                            product_name,
                            product_price,
                            category_id, // Use category_id from the body, default to 1 if not provided
                            result.url, // Store the path to the uploaded image
                        ]);

                        return res.json(newProduct.rows[0]);
                    }
                }
            );
        } catch (error) {
            console.error("Error adding product:", error);
            res.status(500).json({ message: "Error adding product" });
        }
    }
);

router.post("/add/category", jwtAuthorize, async (req, res) => {
    try {
        const { category_name } = req.body;
        const query = `INSERT INTO categories (category_name) VALUES ($1) RETURNING *`;
        const newCategory = await pool.query(query, [category_name]);
        return res.json(newCategory.rows[0]);
    } catch (error) {
        console.error("Error adding category:", error);
        res.status(500).json({ message: "Error adding category" });
    }
});

router.patch(
    "/update/category/:category_id",
    jwtAuthorize,
    async (req, res) => {
        try {
            const { category_id } = req.params;
            const { category_name } = req.body;

            // Validate input (optional but recommended)
            if (!category_name) {
                return res
                    .status(400)
                    .json({ message: "Category name is required" });
            }

            // Update the category in the database
            const query = `
            UPDATE categories 
            SET category_name = $1 
            WHERE category_id = $2 
            RETURNING *`;

            const updatedCategory = await pool.query(query, [
                category_name,
                category_id,
            ]);

            // Check if category exists
            if (updatedCategory.rows.length === 0) {
                return res.status(404).json({ message: "Category not found" });
            }

            return res.json(updatedCategory.rows[0]);
        } catch (error) {
            console.error("Error updating category:", error);
            res.status(500).json({ message: "Error updating category" });
        }
    }
);

router.patch(
    "/update/delete/category/:category_id",
    jwtAuthorize,
    async (req, res) => {
        try {
            const { category_id } = req.params;
            const { status } = req.body;

            // Validate input (optional but recommended)
            if (!category_id) {
                return res
                    .status(400)
                    .json({ message: "Category ID is required" });
            }

            // Update the category in the database
            const query = `
            UPDATE categories 
            SET status = $1 
            WHERE category_id = $2 
            RETURNING *`;

            const updatedCategory = await pool.query(query, [
                status,
                category_id,
            ]);

            // Check if category exists
            if (updatedCategory.rows.length === 0) {
                return res.status(404).json({ message: "Category not found" });
            }

            return res.json(updatedCategory.rows[0]);
        } catch (error) {
            console.error("Error updating category:", error);
            res.status(500).json({ message: "Error updating category" });
        }
    }
);

router.put(
    "/update/product/:product_id",
    jwtAuthorize,
    upload.single("product_image"), // Handle single file upload
    async (req, res) => {
        const { product_id } = req.params;
        const { product_name, product_price, category_id } = req.body;
        const product_image = req.file?.filename; // File will be undefined if no new image is uploaded

        try {
            // Check if the product exists
            const checkQuery = `SELECT * FROM products WHERE product_id = $1`;
            const checkProduct = await pool.query(checkQuery, [product_id]);

            if (checkProduct.rowCount === 0) {
                return res.status(404).json({ message: "Product not found" });
            }

            // Update query for the product
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
                        const query = `
                UPDATE products
                SET 
                    product_name = $1, 
                    product_price = $2, 
                    category_id = $3, 
                    product_image = COALESCE($4, product_image)
                WHERE product_id = $5
                RETURNING *;
            `;

                        // Execute the update query
                        const updatedProduct = await pool.query(query, [
                            product_name,
                            product_price,
                            category_id,
                            result.url,
                            product_id,
                        ]);

                        return res.json({
                            message: "Product updated successfully",
                            product: updatedProduct.rows[0],
                        });
                    }
                }
            );
        } catch (error) {
            console.error("Error updating product:", error);
            res.status(500).json({ message: "Error updating product" });
        }
    }
);

module.exports = router;
