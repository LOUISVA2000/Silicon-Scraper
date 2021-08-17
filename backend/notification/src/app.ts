import express from 'express';
import 'reflect-metadata';
import { connection } from './config';
import subscribe from './controller/subscribe.controller';
import { initialise } from './firebase/firebase.initialise';
import Listener from './listener/listener';

export const app = express();
const port = process.env.PORT || 3000;

/**
 * Use listener and wait for changes to database
 * When a change is discovered, check if any users have the product in their watchlist
 * Use broadcast to send messages to devices

/**
 * Create connection to database for typeorm and load environment variables
 */
connection();

/**
 * Intitialise firebase app
 */
initialise();

/**
 * Start database listener
 */
const listener = new Listener();

app.use(express.json());
app.use(subscribe);