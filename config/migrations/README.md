# 📊 ERADIL MÜFREDAT DATABASE MİGRATIONS

## 🎯 İki Ayrı Database

1. **digibuch_db** - Müfredat içerikleri (uniteler, aktiviteler)
2. **izinler_db** - Erişim izinleri (okul/öğretmen/sınıf)

---

## 🚀 Migration Sırası

### 1️⃣ Digibuch Database (İçerikler)

**Railway pgAdmin'de:**
1. `digibuch_db` (railway) veritabanına bağlan
2. Query Tool'u aç
3. `01-digibuch-schema.sql` dosyasını çalıştır

**Oluşturulan tablolar:**
- ✅ `uniteler` - Müfredat üniteleri (Hallo, ABC, etc.)
- ✅ `aktiviteler` - Aktiviteler (video, oyun, alıştırma)
- ✅ `oyunlar` - Oyunlar
- ✅ `tamamlanan_aktiviteler` - Öğrenci tamamlamaları
- ✅ `unite_ilerlemeleri` - Öğrenci ilerleme özeti

### 2️⃣ İzinler Database (Erişim Kontrol)

**Railway pgAdmin'de:**
1. `izinler_db` (railway) veritabanına bağlan
2. Query Tool'u aç
3. `02-izinler-schema.sql` dosyasını çalıştır

**Oluşturulan tablolar:**
- ✅ `mufredat_izinleri` - İzin atamaları (SADECE ADMİN!)
- ✅ `izin_gecmisi` - İzin değişiklik log'u
- ✅ `v_okul_izin_ozeti` - Okul izin özeti (VIEW)
- ✅ `v_ogretmen_izin_ozeti` - Öğretmen izin özeti (VIEW)
- ✅ `v_sinif_izin_ozeti` - Sınıf izin özeti (VIEW)

---

## 🔍 Test Sorguları

### Digibuch DB Test
```sql
-- Üniteleri listele
SELECT * FROM uniteler ORDER BY sira_no;

-- Aktiviteleri listele
SELECT 
  u.baslik as unite,
  a.baslik as aktivite,
  a.tip,
  a.toplam_puan,
  a.sira_no
FROM aktiviteler a
JOIN uniteler u ON a.unite_id = u.id
ORDER BY u.sira_no, a.sira_no;

-- Öğrenci ilerleme
SELECT 
  ui.*,
  u.baslik as unite_baslik
FROM unite_ilerlemeleri ui
JOIN uniteler u ON ui.unite_id = u.id
WHERE ui.ogrenci_id = 14; -- Örnek öğrenci
```

### İzinler DB Test
```sql
-- İzinleri listele
SELECT 
  mi.id,
  mi.unite_id,
  mi.izin_turu,
  mi.okul_id,
  mi.ogretmen_id,
  mi.sinif_id,
  mi.durum,
  mi.atama_tarihi
FROM mufredat_izinleri mi
WHERE mi.durum = 'aktif'
ORDER BY mi.atama_tarihi DESC;

-- Okul bazında izin özeti
SELECT * FROM v_okul_izin_ozeti;

-- İzin geçmişi
SELECT 
  ig.islem,
  ig.unite_id,
  ig.izin_turu,
  ig.islem_tarihi,
  ig.admin_id
FROM izin_gecmisi ig
ORDER BY ig.islem_tarihi DESC
LIMIT 20;
```

---

## 📝 Örnek İzin Atama (Admin İçin)

```sql
-- Okul bazında izin (tüm okula erişim)
INSERT INTO mufredat_izinleri (
  unite_id, izin_turu, okul_id, atayan_admin_id
) VALUES (
  1, -- unite_id (örn: Hallo)
  'okul',
  6, -- okul_id
  1  -- admin_id
);

-- Öğretmen bazında izin (sadece o öğretmene)
INSERT INTO mufredat_izinleri (
  unite_id, izin_turu, ogretmen_id, atayan_admin_id
) VALUES (
  1, -- unite_id
  'ogretmen',
  11, -- ogretmen_id
  1   -- admin_id
);

-- Sınıf bazında izin (sadece o sınıfa)
INSERT INTO mufredat_izinleri (
  unite_id, izin_turu, sinif_id, atayan_admin_id
) VALUES (
  1, -- unite_id
  'sinif',
  6, -- sinif_id
  1  -- admin_id
);
```

---

## ⚠️ ÖNEMLİ NOTLAR

1. **İzin Hiyerarşisi:**
   - Okul izni > Öğretmen izni > Sınıf izni
   - Okula izin varsa, o okuldaki tüm öğretmen/öğrenciler erişebilir
   - Öğretmene izin varsa, sadece o öğretmen erişebilir
   - Sınıfa izin varsa, sadece o sınıftaki öğrenciler erişebilir

2. **Sadece Admin Atayabilir:**
   - Öğretmenler izin **atayamaz**, sadece **görüntüleyebilir**
   - Backend `authorizeRoles('admin')` ile kontrol edilecek

3. **Trigger'lar:**
   - Aktivite tamamlandığında `unite_ilerlemeleri` otomatik güncellenir
   - İzin değişiklikleri otomatik log'lanır (`izin_gecmisi`)

4. **JSON İçerik:**
   - `aktiviteler.icerik` JSONB: Tüm aktivite data'sı
   - `aktiviteler.yonerge_ses` JSONB: Ses dosyası bilgisi
   - `aktiviteler.ui_butonlar` JSONB: UI buton görselleri

---

## 🔧 Rollback (Geri Alma)

Tabloları silmek için:

```sql
-- Digibuch DB
DROP TABLE IF EXISTS unite_ilerlemeleri CASCADE;
DROP TABLE IF EXISTS tamamlanan_aktiviteler CASCADE;
DROP TABLE IF EXISTS oyunlar CASCADE;
DROP TABLE IF EXISTS aktiviteler CASCADE;
DROP TABLE IF EXISTS uniteler CASCADE;
DROP TYPE IF EXISTS aktivite_tipi CASCADE;
DROP TYPE IF EXISTS durum_enum CASCADE;

-- İzinler DB
DROP VIEW IF EXISTS v_sinif_izin_ozeti CASCADE;
DROP VIEW IF EXISTS v_ogretmen_izin_ozeti CASCADE;
DROP VIEW IF EXISTS v_okul_izin_ozeti CASCADE;
DROP TABLE IF EXISTS izin_gecmisi CASCADE;
DROP TABLE IF EXISTS mufredat_izinleri CASCADE;
DROP TYPE IF EXISTS izin_turu_enum CASCADE;
DROP TYPE IF EXISTS izin_durum_enum CASCADE;
```

---

## ✅ Migration Tamamlandı mı?

- [ ] `digibuch_db` tabloları oluşturuldu
- [ ] `izinler_db` tabloları oluşturuldu
- [ ] Test sorguları çalıştı
- [ ] Backend `.env` dosyasında DB URL'leri doğru
- [ ] Backend başarıyla bağlandı (health check)
