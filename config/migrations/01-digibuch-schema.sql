/**
 * DIGIBUCH DATABASE SCHEMA
 * Müfredat içerikleri (uniteler, aktiviteler, oyunlar)
 */

-- ===== ENUM TYPES =====
CREATE TYPE aktivite_tipi AS ENUM (
  'video',
  'buzzy_beezy_listen',
  'buzzy_beezy_match',
  'buzzy_beezy_audio_visual_match',
  'buzzy_beezy_write',
  'buzzy_beezy_text_drop',
  'buzzy_beezy_text_choose',
  'buzzy_beezy_image_order_swap'
);

CREATE TYPE durum_enum AS ENUM ('aktif', 'pasif', 'arsiv');

-- ===== ÜNİTELER (Units) =====
CREATE TABLE IF NOT EXISTS uniteler (
  id SERIAL PRIMARY KEY,
  
  -- Temel bilgiler
  baslik VARCHAR(255) NOT NULL,
  aciklama TEXT,
  slug VARCHAR(255) UNIQUE NOT NULL, -- URL için (örn: 'hallo', 'abc')
  icon VARCHAR(255), -- URL veya emoji
  
  -- Görsel
  kapak_gorseli TEXT, -- Ünite kapak görseli
  arkaplan_gorseli TEXT, -- Aktiviteler için default arkaplan
  
  -- Sıralama ve durum
  sira_no INTEGER NOT NULL DEFAULT 0,
  durum durum_enum DEFAULT 'aktif',
  
  -- Puan sistemi
  toplam_puan INTEGER DEFAULT 0, -- Ünite toplam puanı
  
  -- Metadata
  olusturan_id INTEGER, -- Admin ID
  olusturma_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  guncelleme_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  CONSTRAINT uniteler_sira_no_unique UNIQUE (sira_no)
);

CREATE INDEX idx_uniteler_slug ON uniteler(slug);
CREATE INDEX idx_uniteler_durum ON uniteler(durum);
CREATE INDEX idx_uniteler_sira ON uniteler(sira_no);

-- ===== AKTİVİTELER (Activities) =====
CREATE TABLE IF NOT EXISTS aktiviteler (
  id SERIAL PRIMARY KEY,
  
  -- Ünite ilişkisi
  unite_id INTEGER NOT NULL REFERENCES uniteler(id) ON DELETE CASCADE,
  
  -- Temel bilgiler
  aktivite_id VARCHAR(100) NOT NULL, -- Unique ID (örn: 'hallo_video_intro')
  tip aktivite_tipi NOT NULL,
  baslik VARCHAR(255) NOT NULL,
  
  -- İçerik (JSON formatında)
  icerik JSONB NOT NULL, -- Tüm aktivite data'sı (instruction, questions, parts, vb.)
  
  -- Görseller
  arkaplan_gorseli TEXT,
  
  -- Ses/Video
  yonerge_ses JSONB, -- { storage: { bucket, path } } veya { url }
  video_url TEXT, -- Video aktiviteleri için
  
  -- UI butonları
  ui_butonlar JSONB, -- { soundButton, progressButton, fullscreenButton, ... }
  
  -- Puan
  toplam_puan INTEGER DEFAULT 0,
  
  -- Sıralama
  sira_no INTEGER NOT NULL,
  
  -- Kilit sistemi (ilerlemeli öğrenme)
  onceki_aktivite_id INTEGER REFERENCES aktiviteler(id),
  
  -- Durum
  durum durum_enum DEFAULT 'aktif',
  
  -- Metadata
  olusturma_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  guncelleme_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  CONSTRAINT aktiviteler_unite_aktivite_id_unique UNIQUE (unite_id, aktivite_id),
  CONSTRAINT aktiviteler_unite_sira_unique UNIQUE (unite_id, sira_no)
);

CREATE INDEX idx_aktiviteler_unite ON aktiviteler(unite_id);
CREATE INDEX idx_aktiviteler_tip ON aktiviteler(tip);
CREATE INDEX idx_aktiviteler_durum ON aktiviteler(durum);
CREATE INDEX idx_aktiviteler_sira ON aktiviteler(unite_id, sira_no);

-- ===== OYUNLAR (Games) =====
CREATE TABLE IF NOT EXISTS oyunlar (
  id SERIAL PRIMARY KEY,
  
  -- Ünite ilişkisi
  unite_id INTEGER NOT NULL REFERENCES uniteler(id) ON DELETE CASCADE,
  
  -- Temel bilgiler
  oyun_id VARCHAR(100) NOT NULL, -- Unique ID (örn: 'hallo-game-1')
  baslik VARCHAR(255) NOT NULL,
  aciklama TEXT,
  
  -- Görsel
  kapak_gorseli TEXT,
  
  -- Oyun data (component adı veya URL)
  component_adi VARCHAR(100), -- Frontend component adı (örn: 'HalloGame1')
  
  -- Sıralama
  sira_no INTEGER NOT NULL,
  
  -- Durum
  durum durum_enum DEFAULT 'aktif',
  
  -- Metadata
  olusturma_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  guncelleme_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  CONSTRAINT oyunlar_unite_oyun_id_unique UNIQUE (unite_id, oyun_id),
  CONSTRAINT oyunlar_unite_sira_unique UNIQUE (unite_id, sira_no)
);

CREATE INDEX idx_oyunlar_unite ON oyunlar(unite_id);
CREATE INDEX idx_oyunlar_durum ON oyunlar(durum);

-- ===== TAMAMLANAN AKTİVİTELER (Completed Activities) =====
CREATE TABLE IF NOT EXISTS tamamlanan_aktiviteler (
  id SERIAL PRIMARY KEY,
  
  -- İlişkiler
  ogrenci_id INTEGER NOT NULL, -- Kullanıcı ID (kullanici_db'den)
  unite_id INTEGER NOT NULL REFERENCES uniteler(id) ON DELETE CASCADE,
  aktivite_id INTEGER NOT NULL REFERENCES aktiviteler(id) ON DELETE CASCADE,
  
  -- Tamamlanma bilgisi
  tamamlandi BOOLEAN DEFAULT TRUE,
  kazanilan_puan INTEGER DEFAULT 0,
  
  -- Aktivite detayı (JSON)
  detay JSONB, -- Cevaplar, süre, doğru/yanlış sayısı vs.
  
  -- Tarihler
  tamamlanma_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  CONSTRAINT tamamlanan_aktiviteler_unique UNIQUE (ogrenci_id, aktivite_id)
);

CREATE INDEX idx_tamamlanan_ogrenci ON tamamlanan_aktiviteler(ogrenci_id);
CREATE INDEX idx_tamamlanan_unite ON tamamlanan_aktiviteler(unite_id);
CREATE INDEX idx_tamamlanan_aktivite ON tamamlanan_aktiviteler(aktivite_id);

-- ===== ÜNİTE İLERLEMESİ (Unit Progress) - Özet View =====
CREATE TABLE IF NOT EXISTS unite_ilerlemeleri (
  id SERIAL PRIMARY KEY,
  
  -- İlişkiler
  ogrenci_id INTEGER NOT NULL,
  unite_id INTEGER NOT NULL REFERENCES uniteler(id) ON DELETE CASCADE,
  
  -- İstatistikler
  tamamlanan_aktivite_sayisi INTEGER DEFAULT 0,
  toplam_aktivite_sayisi INTEGER DEFAULT 0,
  kazanilan_puan INTEGER DEFAULT 0,
  toplam_puan INTEGER DEFAULT 0,
  
  -- Son aktivite
  son_aktivite_id INTEGER REFERENCES aktiviteler(id),
  son_erisim_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  -- Tarihler
  olusturma_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  guncelleme_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  CONSTRAINT unite_ilerlemeleri_unique UNIQUE (ogrenci_id, unite_id)
);

CREATE INDEX idx_unite_ilerlemeleri_ogrenci ON unite_ilerlemeleri(ogrenci_id);
CREATE INDEX idx_unite_ilerlemeleri_unite ON unite_ilerlemeleri(unite_id);

-- ===== TRİGGERLAR =====

-- Aktivite tamamlandığında unite ilerlemesini güncelle
CREATE OR REPLACE FUNCTION update_unite_ilerlemesi()
RETURNS TRIGGER AS $$
BEGIN
  -- Unite ilerlemesi yoksa oluştur
  INSERT INTO unite_ilerlemeleri (
    ogrenci_id, 
    unite_id, 
    tamamlanan_aktivite_sayisi,
    kazanilan_puan,
    son_aktivite_id
  )
  VALUES (
    NEW.ogrenci_id,
    NEW.unite_id,
    1,
    NEW.kazanilan_puan,
    NEW.aktivite_id
  )
  ON CONFLICT (ogrenci_id, unite_id) 
  DO UPDATE SET
    tamamlanan_aktivite_sayisi = unite_ilerlemeleri.tamamlanan_aktivite_sayisi + 1,
    kazanilan_puan = unite_ilerlemeleri.kazanilan_puan + NEW.kazanilan_puan,
    son_aktivite_id = NEW.aktivite_id,
    son_erisim_tarihi = CURRENT_TIMESTAMP,
    guncelleme_tarihi = CURRENT_TIMESTAMP;
    
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_update_unite_ilerlemesi
  AFTER INSERT ON tamamlanan_aktiviteler
  FOR EACH ROW
  EXECUTE FUNCTION update_unite_ilerlemesi();

-- Güncelleme tarihlerini otomatik güncelle
CREATE OR REPLACE FUNCTION update_guncelleme_tarihi()
RETURNS TRIGGER AS $$
BEGIN
  NEW.guncelleme_tarihi = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_uniteler_guncelleme
  BEFORE UPDATE ON uniteler
  FOR EACH ROW
  EXECUTE FUNCTION update_guncelleme_tarihi();

CREATE TRIGGER trigger_aktiviteler_guncelleme
  BEFORE UPDATE ON aktiviteler
  FOR EACH ROW
  EXECUTE FUNCTION update_guncelleme_tarihi();

-- ===== SEED DATA (Örnek) =====

-- Örnek ünite
INSERT INTO uniteler (baslik, slug, aciklama, sira_no, durum) 
VALUES 
  ('Hallo!', 'hallo', 'Almanca selamlaşma ve tanışma', 1, 'aktif')
ON CONFLICT (slug) DO NOTHING;

COMMENT ON TABLE uniteler IS 'Müfredat üniteleri (Hallo, ABC, etc.)';
COMMENT ON TABLE aktiviteler IS 'Ünite aktiviteleri (video, oyun, alıştırma)';
COMMENT ON TABLE oyunlar IS 'Üniteye bağlı eğlenceli oyunlar';
COMMENT ON TABLE tamamlanan_aktiviteler IS 'Öğrencilerin tamamladığı aktiviteler';
COMMENT ON TABLE unite_ilerlemeleri IS 'Öğrencilerin ünite bazında ilerleme durumu';
