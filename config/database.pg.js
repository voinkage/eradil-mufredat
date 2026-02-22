/**
 * POSTGRESQL DATABASE CONFIGURATION
 * Müfredat içerikleri (kitaplar) – tüm içerikler herkese açık, izin/atama yok
 */

import pg from 'pg';
const { Pool } = pg;
import dotenv from 'dotenv';
import { URL } from 'url';

dotenv.config();

/**
 * PostgreSQL connection URL'ini parse et
 */
function parseConnectionUrl(urlString) {
  if (!urlString) return null;
  
  try {
    const url = new URL(urlString);
    return {
      host: url.hostname,
      port: parseInt(url.port) || 5432,
      user: url.username,
      password: url.password,
      database: url.pathname.slice(1), // Remove leading '/'
      ssl: { rejectUnauthorized: false },
      max: parseInt(process.env.DB_CONNECTION_LIMIT) || 10,
      connectionTimeoutMillis: parseInt(process.env.DB_CONNECT_TIMEOUT) || 60000,
      idleTimeoutMillis: parseInt(process.env.DB_IDLE_TIMEOUT) || 30000
    };
  } catch (error) {
    console.error('❌ URL parse hatası:', error.message);
    return null;
  }
}

// ===== MÜFREDAT İÇERİK DATABASE (kitaplar, uniteler) =====
let digibuchConfig;

if (process.env.DIGIBUCH_DB_URL) {
  digibuchConfig = parseConnectionUrl(process.env.DIGIBUCH_DB_URL);
} else {
  digibuchConfig = {
    host: process.env.DIGIBUCH_DB_HOST || 'localhost',
    port: parseInt(process.env.DIGIBUCH_DB_PORT) || 5432,
    user: process.env.DIGIBUCH_DB_USER || 'postgres',
    password: process.env.DIGIBUCH_DB_PASSWORD,
    database: process.env.DIGIBUCH_DB_NAME || 'digibuch_db',
    ssl: process.env.DIGIBUCH_DB_SSL === 'true' ? { rejectUnauthorized: false } : false
  };
}

export const digibuchPool = digibuchConfig ? new Pool(digibuchConfig) : null;

// Connection test
if (digibuchPool) {
  digibuchPool.query('SELECT NOW()', (err, res) => {
    if (err) {
      console.error('❌ Müfredat DB bağlantı hatası:', err.message);
    } else {
      console.log('✅ Müfredat DB veritabanına başarıyla bağlandı');
    }
  });
} else {
  console.warn('⚠️ Müfredat DB (DIGIBUCH_DB_URL) yapılandırması eksik!');
}

// Graceful shutdown
process.on('SIGINT', async () => {
  console.log('🔄 Database bağlantıları kapatılıyor...');
  if (digibuchPool) await digibuchPool.end();
  process.exit(0);
});

export default { digibuchPool };
