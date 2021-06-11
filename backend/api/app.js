const express = require('express');
const productRoutes = require('./routes/product.js');
const userController = require('./users/controller/userController.js');

const app = express();

app.use(express.json());

app.use('/products', productRoutes);
//app.use('/users', userController);

module.exports = app;   // for testing
