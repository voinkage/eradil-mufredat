/**
 * İZİNLER DATABASE SCHEMA
 * Okul/Öğretmen/Sınıf bazında müfredat erişim izinleri
 * SADECE ADMİN ATAYAB İLİR!
 */

-- ===== ENUM TYPES =====
CREATE TYPE izin_turu_enum AS ENUM ('okul', 'ogretmen', 'sinif');
CREATE TYPE izin_durum_enum AS ENUM ('aktif', 'pasif');

-- ===== MÜFREDAT İZİNLERİ =====
CREATE TABLE IF NOT EXISTS mufredat_izinleri (
  id SERIAL PRIMARY KEY,
  
  -- Ünite ilişkisi (digibuch_db'den)
  unite_id INTEGER NOT NULL, -- digibuch_db.uniteler.id
  
  -- İzin türü ve hedef
  izin_turu izin_turu_enum NOT NULL,
  
  -- Hedef ID'ler (organizasyon_db ve kullanici_db'den)
  okul_id INTEGER, -- organizasyon_db.okullar.id
  ogretmen_id INTEGER, -- kullanici_db.kullanicilar.id (rol='ogretmen')
  sinif_id INTEGER, -- organizasyon_db.siniflar.id
  
  -- Durum
  durum izin_durum_enum DEFAULT 'aktif',
  
  -- Metadata
  atayan_admin_id INTEGER NOT NULL, -- Sadece admin atayabilir!
  atama_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  guncelleme_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  -- Constraints
  CONSTRAINT mufredat_izinleri_okul_check 
    CHECK (
      (izin_turu = 'okul' AND okul_id IS NOT NULL AND ogretmen_id IS NULL AND sinif_id IS NULL) OR
      (izin_turu = 'ogretmen' AND ogretmen_id IS NOT NULL AND okul_id IS NULL AND sinif_id IS NULL) OR
      (izin_turu = 'sinif' AND sinif_id IS NOT NULL AND okul_id IS NULL AND ogretmen_id IS NULL)
    ),
  
  -- Aynı hedef için duplicate izin olmasın
  CONSTRAINT mufredat_izinleri_unique
    UNIQUE NULLS NOT DISTINCT (unite_id, okul_id, ogretmen_id, sinif_id)
);

CREATE INDEX idx_mufredat_izinleri_unite ON mufredat_izinleri(unite_id);
CREATE INDEX idx_mufredat_izinleri_okul ON mufredat_izinleri(okul_id) WHERE okul_id IS NOT NULL;
CREATE INDEX idx_mufredat_izinleri_ogretmen ON mufredat_izinleri(ogretmen_id) WHERE ogretmen_id IS NOT NULL;
CREATE INDEX idx_mufredat_izinleri_sinif ON mufredat_izinleri(sinif_id) WHERE sinif_id IS NOT NULL;
CREATE INDEX idx_mufredat_izinleri_durum ON mufredat_izinleri(durum);

-- ===== İZİN GEÇMİŞİ (Audit Log) =====
CREATE TABLE IF NOT EXISTS izin_gecmisi (
  id SERIAL PRIMARY KEY,
  
  -- İşlem
  islem VARCHAR(50) NOT NULL, -- 'eklendi', 'kaldirildi', 'guncellendi'
  
  -- İzin bilgileri
  unite_id INTEGER NOT NULL,
  izin_turu izin_turu_enum NOT NULL,
  okul_id INTEGER,
  ogretmen_id INTEGER,
  sinif_id INTEGER,
  
  -- Admin bilgisi
  admin_id INTEGER NOT NULL,
  islem_tarihi TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  
  -- Eski ve yeni durum (JSON)
  eski_durum JSONB,
  yeni_durum JSONB
);

CREATE INDEX idx_izin_gecmisi_unite ON izin_gecmisi(unite_id);
CREATE INDEX idx_izin_gecmisi_admin ON izin_gecmisi(admin_id);
CREATE INDEX idx_izin_gecmisi_tarih ON izin_gecmisi(islem_tarihi DESC);

-- ===== TRİGGERLAR =====

-- Güncelleme tarihini otomatik güncelle
CREATE OR REPLACE FUNCTION update_izin_guncelleme_tarihi()
RETURNS TRIGGER AS $$
BEGIN
  NEW.guncelleme_tarihi = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_mufredat_izinleri_guncelleme
  BEFORE UPDATE ON mufredat_izinleri
  FOR EACH ROW
  EXECUTE FUNCTION update_izin_guncelleme_tarihi();

-- İzin değişikliklerini loglama
CREATE OR REPLACE FUNCTION log_izin_degisikligi()
RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'INSERT') THEN
    INSERT INTO izin_gecmisi (
      islem, unite_id, izin_turu, okul_id, ogretmen_id, sinif_id, admin_id, yeni_durum
    ) VALUES (
      'eklendi', 
      NEW.unite_id, 
      NEW.izin_turu, 
      NEW.okul_id, 
      NEW.ogretmen_id, 
      NEW.sinif_id, 
      NEW.atayan_admin_id,
      to_jsonb(NEW)
    );
    RETURN NEW;
    
  ELSIF (TG_OP = 'UPDATE') THEN
    INSERT INTO izin_gecmisi (
      islem, unite_id, izin_turu, okul_id, ogretmen_id, sinif_id, admin_id, eski_durum, yeni_durum
    ) VALUES (
      'guncellendi',
      NEW.unite_id,
      NEW.izin_turu,
      NEW.okul_id,
      NEW.ogretmen_id,
      NEW.sinif_id,
      NEW.atayan_admin_id,
      to_jsonb(OLD),
      to_jsonb(NEW)
    );
    RETURN NEW;
    
  ELSIF (TG_OP = 'DELETE') THEN
    INSERT INTO izin_gecmisi (
      islem, unite_id, izin_turu, okul_id, ogretmen_id, sinif_id, admin_id, eski_durum
    ) VALUES (
      'kaldirildi',
      OLD.unite_id,
      OLD.izin_turu,
      OLD.okul_id,
      OLD.ogretmen_id,
      OLD.sinif_id,
      OLD.atayan_admin_id,
      to_jsonb(OLD)
    );
    RETURN OLD;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_log_izin_degisikligi
  AFTER INSERT OR UPDATE OR DELETE ON mufredat_izinleri
  FOR EACH ROW
  EXECUTE FUNCTION log_izin_degisikligi();

-- ===== YARDIMCI VIEW'LAR =====

-- Okul bazında izin özeti
CREATE OR REPLACE VIEW v_okul_izin_ozeti AS
SELECT 
  okul_id,
  COUNT(DISTINCT unite_id) as toplam_unite_sayisi,
  COUNT(*) FILTER (WHERE durum = 'aktif') as aktif_izin_sayisi,
  COUNT(*) FILTER (WHERE durum = 'pasif') as pasif_izin_sayisi,
  MAX(atama_tarihi) as son_atama_tarihi
FROM mufredat_izinleri
WHERE okul_id IS NOT NULL
GROUP BY okul_id;

-- Öğretmen bazında izin özeti
CREATE OR REPLACE VIEW v_ogretmen_izin_ozeti AS
SELECT 
  ogretmen_id,
  COUNT(DISTINCT unite_id) as toplam_unite_sayisi,
  COUNT(*) FILTER (WHERE durum = 'aktif') as aktif_izin_sayisi,
  COUNT(*) FILTER (WHERE durum = 'pasif') as pasif_izin_sayisi,
  MAX(atama_tarihi) as son_atama_tarihi
FROM mufredat_izinleri
WHERE ogretmen_id IS NOT NULL
GROUP BY ogretmen_id;

-- Sınıf bazında izin özeti
CREATE OR REPLACE VIEW v_sinif_izin_ozeti AS
SELECT 
  sinif_id,
  COUNT(DISTINCT unite_id) as toplam_unite_sayisi,
  COUNT(*) FILTER (WHERE durum = 'aktif') as aktif_izin_sayisi,
  COUNT(*) FILTER (WHERE durum = 'pasif') as pasif_izin_sayisi,
  MAX(atama_tarihi) as son_atama_tarihi
FROM mufredat_izinleri
WHERE sinif_id IS NOT NULL
GROUP BY sinif_id;

-- ===== COMMENTS =====
COMMENT ON TABLE mufredat_izinleri IS 'Okul/Öğretmen/Sınıf bazında müfredat erişim izinleri (SADECE ADMİN ATAYAB İLİR!)';
COMMENT ON TABLE izin_gecmisi IS 'İzin değişiklik geçmişi (audit log)';
COMMENT ON COLUMN mufredat_izinleri.izin_turu IS 'okul: Tüm okula erişim, ogretmen: Sadece öğretmene, sinif: Sadece sınıfa';
COMMENT ON COLUMN mufredat_izinleri.atayan_admin_id IS 'İzni atayan admin kullanıcısı (sadece admin atayabilir!)';
