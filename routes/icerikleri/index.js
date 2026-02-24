/**
 * İÇERİKLERİ ROUTES - ANA ROUTER
 * Kitaplar: öğrenci/öğretmen listesi + detay (çözüm). Admin CRUD erax-admin'de.
 */

import express from 'express';
import kitaplarRouter from './kitaplar.js';

const router = express.Router();

router.use('/kitaplar', kitaplarRouter);

export default router;
