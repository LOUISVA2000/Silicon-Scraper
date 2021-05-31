import express from 'express';
import routes from './routes/product.js';
import userRoutes from './routes/userRoutes.js';

const app: express.Application = express();
const port = process.env.PORT || 3000;

app.use(express.json());
app.use(routes);
app.use('/user', userRoutes);

app.listen(port, () => {
    console.log(`Listening on port ${port}`);
});