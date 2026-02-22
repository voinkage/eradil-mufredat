/**
 * İÇERİKLERİ ROUTES - ANA ROUTER
 * Kitaplar (ünite sihirbazı) – uniteler/aktiviteler/ilerleme Digibuch kaldırıldı
 */

import express from 'express';
import kitaplarRouter from './kitaplar.js';

const router = express.Router();

router.use('/kitaplar', kitaplarRouter);

export default router;
