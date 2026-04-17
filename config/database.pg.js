/**
 * POSTGRESQL DATABASE CONFIGURATION
 * Müfredat içerikleri (kitaplar) — liste/detay: IZINLER_DB + KULLANICI/ORGANIZASYON ile süzülür
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

function createPoolFromUrl (connectionString, dbName) {
  if (!connectionString) {
    console.warn(`⚠️ ${dbName} için connection string yok (içerik izinleri isteğe bağlı)`);
    return null;
  }
  return new Pool({
    connectionString,
    max: parseInt(process.env.DB_CONNECTION_LIMIT) || 10,
    idleTimeoutMillis: parseInt(process.env.DB_IDLE_TIMEOUT) || 30000,
    connectionTimeoutMillis: parseInt(process.env.DB_CONNECT_TIMEOUT) || 60000,
    ssl: { rejectUnauthorized: false }
  });
}

/** Öğrenci/öğretmen okul & sınıf bağlamı (izin filtreleme) */
export const kullaniciPool = createPoolFromUrl(process.env.KULLANICI_DB_URL, 'KULLANICI_DB');
export const organizasyonPool = createPoolFromUrl(process.env.ORGANIZASYON_DB_URL, 'ORGANIZASYON_DB');
/** Kitap/etkinlik × okul kuralları */
export const izinlerPool = createPoolFromUrl(process.env.IZINLER_DB_URL, 'IZINLER_DB');

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

for (const [name, p] of [['KULLANICI_DB', kullaniciPool], ['ORGANIZASYON_DB', organizasyonPool], ['IZINLER_DB', izinlerPool]]) {
  if (p) {
    p.query('SELECT NOW()').then(() => console.log(`✅ Müfredat — ${name} bağlandı`)).catch((e) => console.error(`❌ ${name}:`, e.message));
  }
}

// Graceful shutdown
process.on('SIGINT', async () => {
  console.log('🔄 Database bağlantıları kapatılıyor...');
  if (digibuchPool) await digibuchPool.end();
  if (kullaniciPool) await kullaniciPool.end();
  if (organizasyonPool) await organizasyonPool.end();
  if (izinlerPool) await izinlerPool.end();
  process.exit(0);
});

export default { digibuchPool, kullaniciPool, organizasyonPool, izinlerPool };
