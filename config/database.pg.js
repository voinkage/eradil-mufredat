/**
 * POSTGRESQL DATABASE CONFIGURATION
 * İki ayrı database: digibuch_db (içerikler) ve izinler_db (erişim kontrol)
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

// ===== DİGİBUCH DATABASE (Müfredat İçerikleri) =====
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
      console.error('❌ DIGIBUCH_DB bağlantı hatası:', err.message);
    } else {
      console.log('✅ DIGIBUCH_DB veritabanına başarıyla bağlandı: railway');
    }
  });
} else {
  console.warn('⚠️ DIGIBUCH_DB yapılandırması eksik!');
}

// ===== İZİNLER DATABASE (Okul/Öğretmen/Sınıf İzinleri) =====
let izinlerConfig;

if (process.env.IZINLER_DB_URL) {
  izinlerConfig = parseConnectionUrl(process.env.IZINLER_DB_URL);
} else {
  izinlerConfig = {
    host: process.env.IZINLER_DB_HOST || 'localhost',
    port: parseInt(process.env.IZINLER_DB_PORT) || 5432,
    user: process.env.IZINLER_DB_USER || 'postgres',
    password: process.env.IZINLER_DB_PASSWORD,
    database: process.env.IZINLER_DB_NAME || 'izinler_db',
    ssl: process.env.IZINLER_DB_SSL === 'true' ? { rejectUnauthorized: false } : false
  };
}

export const izinlerPool = izinlerConfig ? new Pool(izinlerConfig) : null;

// Connection test
if (izinlerPool) {
  izinlerPool.query('SELECT NOW()', (err, res) => {
    if (err) {
      console.error('❌ IZINLER_DB bağlantı hatası:', err.message);
    } else {
      console.log('✅ IZINLER_DB veritabanına başarıyla bağlandı: railway');
    }
  });
} else {
  console.warn('⚠️ IZINLER_DB yapılandırması eksik!');
}

// Graceful shutdown
process.on('SIGINT', async () => {
  console.log('🔄 Database bağlantıları kapatılıyor...');
  if (digibuchPool) await digibuchPool.end();
  if (izinlerPool) await izinlerPool.end();
  process.exit(0);
});

export default { digibuchPool, izinlerPool };
