const jwt = require("jsonwebtoken");
require("dotenv").config();

function jwtGenerator(user_id, user_role) {
    const payload = {
        user: {
            user_id: user_id,
            user_role: user_role,
        },
    };

    return jwt.sign(payload, process.env.SECRET_KEY, { expiresIn: "4h" });
}

module.exports = jwtGenerator;
