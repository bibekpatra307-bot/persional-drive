import express from 'express';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import dotenv from 'dotenv';
import cookieParser from 'cookie-parser';
import { apiRouter } from './server/routes.js';

dotenv.config();

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = process.env.PORT ? parseInt(process.env.PORT, 10) : 3000;

// Parsers
app.use(cookieParser());
app.use(express.json({ limit: '10mb' }));

// API Router
app.use('/api', apiRouter);

// Static files for production build
const distPath = path.resolve(__dirname, 'dist');
app.use(express.static(distPath));

// SPA fallback
app.get('*', (req, res, next) => {
  if (req.path.startsWith('/api')) {
    return next();
  }
  res.sendFile(path.join(distPath, 'index.html'));
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`🚀 Private Cloud server running on http://0.0.0.0:${PORT}`);
});
