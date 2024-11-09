const express = require("express");
const router = express.Router();
const pool = require("../database/coffeeshop.db");
const jwtAuthorize = require("../middleware/jwt.validator");

router.post("/add/order", jwtAuthorize, async (req, res) => {
    try {
        const { order_date, order_type, transaction_number, total } = req.body; // Adjusted to total_amount
        const query = `
            INSERT INTO orders (order_date, order_type, transaction_number, store_id, total_amount)
            VALUES ($1, $2, $3, $4, $5)
            RETURNING *;
        `;

        // Execute the query with the provided values
        const newOrder = await pool.query(query, [
            order_date,
            order_type,
            transaction_number,
            1,
            total,
        ]);

        return res.json(newOrder.rows[0]);
    } catch (error) {
        console.error("Error adding order:", error);
        res.status(500).json({ message: "Error adding order" });
    }
});

router.post("/add/order-list", jwtAuthorize, async (req, res) => {
    try {
        const { order_id, product_id, quantity, sub_total } = req.body; // Adjusted to total_amount
        const query = `
            INSERT INTO order_list (order_id, product_id, quantity, subtotal)
            VALUES ($1, $2, $3, $4)
            RETURNING *;
        `;

        // Execute the query with the provided values
        const newOrder = await pool.query(query, [
            order_id,
            product_id,
            quantity,
            sub_total,
        ]);

        return res.json(newOrder.rows[0]);
    } catch (error) {
        console.error("Error adding order:", error);
        res.status(500).json({ message: "Error adding order" });
    }
});

router.get("/get/orders", jwtAuthorize, async (req, res) => {
    try {
        const query = `
            SELECT orders.*, store_location.store_name
            FROM orders
            JOIN store_location ON orders.store_id = store_location.store_id
            ORDER BY orders.order_date DESC;
        `;

        // Execute the query to get all orders along with store name
        const orders = await pool.query(query);

        return res.json(orders.rows);
    } catch (error) {
        console.error("Error fetching orders:", error);
        res.status(500).json({ message: "Error fetching orders" });
    }
});

router.get("/get/specific-orders", jwtAuthorize, async (req, res) => {
    try {
        const { year, store_id } = req.query; // Get 'year' and 'store_id' from the query parameters
        console.log(year, store_id);
        let query = `
            SELECT orders.*, store_location.store_name
            FROM orders
            JOIN store_location ON orders.store_id = store_location.store_id
            WHERE EXTRACT(YEAR FROM orders.order_date) = $1
        `;

        // Prepare query parameters
        const queryParams = [year];

        // If a store is selected (and it's not 'All'), filter by store_id
        if (store_id && store_id !== "All") {
            query += ` AND orders.store_id = $2`;
            queryParams.push(store_id);
        }

        query += ` ORDER BY orders.order_date DESC`;

        // Execute the query to get orders with the filter conditions
        const orders = await pool.query(query, queryParams);

        return res.json(orders.rows);
    } catch (error) {
        console.error("Error fetching orders:", error);
        res.status(500).json({ message: "Error fetching orders" });
    }
});

router.get("/get/top-sold-products", async (req, res) => {
    try {
        // SQL query to find the top 5 most sold products based on total quantity
        const query = `
            SELECT 
                p.product_id,
                p.product_name,
                SUM(ol.quantity) AS total_quantity
            FROM 
                order_list ol
            INNER JOIN 
                products p ON ol.product_id = p.product_id
            GROUP BY 
                p.product_id, p.product_name
            ORDER BY 
                total_quantity DESC
            LIMIT 5;
        `;
        // Execute the query
        const result = await pool.query(query);

        // Respond with the top 5 most sold products
        return res.json(result.rows);
    } catch (error) {
        console.error("Error fetching top sold products:", error);
        res.status(500).json({ message: "Error fetching top sold products" });
    }
});

router.get("/get/top-sold-products-no-limit/:year", async (req, res) => {
    try {
        // Extract the 'year' parameter from the URL (e.g., /get/top-sold-products/2022)
        const { year } = req.params;

        // Check if the year parameter is valid (e.g., 4-digit year)
        if (!year || isNaN(year) || year.length !== 4) {
            return res.status(400).json({ message: "Invalid year parameter" });
        }

        // SQL query to find the top sold products by year, including total sales amount
        const query = `
            SELECT 
                p.product_id,
                p.product_name,
                SUM(ol.quantity) AS total_quantity,
                SUM(ol.subtotal) AS total_sales
            FROM 
                order_list ol
            INNER JOIN 
                products p ON ol.product_id = p.product_id
            INNER JOIN 
                orders o ON ol.order_id = o.order_id
            WHERE 
                EXTRACT(YEAR FROM o.order_date) = $1  -- Filter by the provided year
            GROUP BY 
                p.product_id, p.product_name
            ORDER BY 
                total_sales DESC;  -- Sort by total sales instead of quantity
        `;

        // Execute the query with the 'year' parameter
        const result = await pool.query(query, [year]);

        // Respond with the top sold products and total sales for the specified year
        return res.json(result.rows);
    } catch (error) {
        console.error("Error fetching top sold products:", error);
        res.status(500).json({ message: "Error fetching top sold products" });
    }
});

router.get("/get/order-list/:order_id", jwtAuthorize, async (req, res) => {
    try {
        const order_id = req.params.order_id;
        const query = `SELECT * FROM order_list inner join products on products.product_id = order_list.product_id WHERE order_id = $1;`;
        const result = await pool.query(query, [order_id]);
        return res.json(result.rows);
    } catch (error) {
        console.error("Error fetching top sold products:", error);
        res.status(500).json({ message: "Error fetching top sold products" });
    }
});

module.exports = router;
