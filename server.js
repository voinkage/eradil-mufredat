/**
 * ERADIL MÜFREDAT BACKEND
 * Dijital müfredat sistemi - Kitaplar (tüm içerikler herkese açık)
 */

import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import dotenv from 'dotenv';
import rateLimit from 'express-rate-limit';
import { digibuchPool } from './config/database.pg.js';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3004;

// ===== MIDDLEWARE =====
app.use(helmet());

// CORS configuration
const corsOrigins = process.env.CORS_ORIGIN 
  ? process.env.CORS_ORIGIN.split(',') 
  : ['http://localhost:5173'];

app.use(cors({
  origin: corsOrigins,
  credentials: process.env.CORS_CREDENTIALS === 'true' || true
}));

// Body parser
app.use(express.json({ 
  limit: process.env.BODY_SIZE_LIMIT || '10mb' 
}));
app.use(express.urlencoded({ 
  extended: true,
  limit: process.env.BODY_SIZE_LIMIT || '10mb' 
}));

// Rate limiting
const limiter = rateLimit({
  windowMs: parseInt(process.env.RATE_LIMIT_WINDOW_MS) || 900000, // 15 dakika
  max: parseInt(process.env.RATE_LIMIT) || 1000
});
app.use(limiter);

// ===== HEALTH CHECK =====
app.get('/health', (req, res) => {
  res.json({
    success: true,
    message: 'ERADIL Müfredat Backend çalışıyor',
    timestamp: new Date().toISOString(),
    databases: {
      mufredat: digibuchPool ? 'connected' : 'not configured'
    }
  });
});

// ===== API ROUTES =====
import mufredatIcerikleri from './routes/icerikleri/index.js';

app.use('/api/mufredat/icerikleri', mufredatIcerikleri);

// ===== 404 HANDLER =====
app.use((req, res) => {
  res.status(404).json({
    success: false,
    message: 'Endpoint bulunamadı'
  });
});

// ===== ERROR HANDLER =====
app.use((err, req, res, next) => {
  console.error('❌ Sunucu hatası:', err);
  res.status(500).json({
    success: false,
    message: process.env.NODE_ENV === 'development' 
      ? err.message 
      : 'Sunucu hatası oluştu'
  });
});

// ===== SERVER START =====
app.listen(PORT, () => {
  console.log('');
  console.log('═══════════════════════════════════════════════════════════');
  console.log('🎓 ERADIL MÜFREDAT BACKEND');
  console.log('═══════════════════════════════════════════════════════════');
  console.log(`🚀 Server çalışıyor: http://localhost:${PORT}`);
  console.log(`📦 Environment: ${process.env.NODE_ENV || 'development'}`);
  console.log(`🔐 JWT Secret: ${process.env.JWT_SECRET ? '✅ Configured' : '❌ Missing'}`);
  console.log('');
  console.log('📊 Database Durumu:');
  console.log(`   • Müfredat DB: ${digibuchPool ? '✅ Connected' : '❌ Not configured'}`);
  console.log('');
  console.log('📡 API Endpoints:');
  console.log('   • GET  /health - Health check');
  console.log('   • /api/mufredat/icerikleri/* - Kitaplar (içerikler herkese açık)');
  console.log('═══════════════════════════════════════════════════════════');
  console.log('');
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('🔄 SIGTERM alındı, sunucu kapatılıyor...');
  process.exit(0);
});
