const express = require("express");
const app = express();
const cors = require("cors");

//middleware

app.use(cors());
app.use(express.json());

app.use("/api", require("./routes/user.routes"));
app.use("/api", require("./routes/products.routes"));
app.use("/api", require("./routes/store.routes"));
app.use("/api", require("./routes/orders.routes"));
app.use("/api", require("./routes/promo.routes"));

app.listen(5000, () => {
    console.log(`Server is starting on port 5000`);
});
