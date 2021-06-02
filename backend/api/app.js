const express = require('express');
const productRoutes = require('./routes/product.js');
const userRoutes = require('./routes/userRoutes.js');

const app = express();

app.use(express.json());
app.use('/products', productRoutes);
app.use('/users', userRoutes);

module.exports = app;   // for testing
