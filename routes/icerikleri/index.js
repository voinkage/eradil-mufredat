/**
 * İÇERİKLERİ ROUTES - ANA ROUTER
 * Tüm içerik modüllerini birleştirir
 */

import express from 'express';
import unitelerRouter from './uniteler.js';
import aktivitelerRouter from './aktiviteler.js';
import ilerlemeRouter from './ilerleme.js';
import kitaplarRouter from './kitaplar.js';

const router = express.Router();

// Modül route'ları
router.use('/uniteler', unitelerRouter);
router.use('/aktiviteler', aktivitelerRouter);
router.use('/ilerleme', ilerlemeRouter);
router.use('/kitaplar', kitaplarRouter);

export default router;
