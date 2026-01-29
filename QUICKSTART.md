# 🚀 DİGİBUCH QUICKSTART GUIDE

## 📋 HANGİ DOSYALAR OLUŞTURULDU?

### ✅ Tamamlanan SQL Migration Dosyaları:

1. **01-digibuch-schema.sql** ✅ (262 satır)
   - Veritabanı şeması (tablolar, trigger'lar, view'lar)
   
2. **02-izinler-schema.sql** ✅ (197 satır)
   - İzin sistemi şeması

3. **03-hallo-seed-data-FIXED.sql** ✅ (YENİ - HATA DÜZELTİLDİ)
   - Hallo ünitesi
   - İlk 3 aktivite (Video + Diyalog + Video)
   
4. **04-hallo-remaining-activities.sql** ✅ (YENİ)
   - Kalan 9 aktivite (Match, Audio-Visual, Write, Text Drop, vb.)

---

## 🎯 HEMEN BAŞLA - 3 ADIM

### ADIM 1: Database Migration'ları Çalıştır

**Railway CLI ile (ÖNERİLEN):**

```bash
# Railway'e login ol
railway login

# Digibuch DB'ye bağlan
railway link

# Migration'ları çalıştır
railway run psql postgresql://postgres:nOmxXsIIOmRphhCJKjVOaoDdpCgFlRnb@crossover.proxy.rlwy.net:38145/railway < backend/eradil-mufredat/config/migrations/01-digibuch-schema.sql

railway run psql postgresql://postgres:nOmxXsIIOmRphhCJKjVOaoDdpCgFlRnb@crossover.proxy.rlwy.net:38145/railway < backend/eradil-mufredat/config/migrations/03-hallo-seed-data-FIXED.sql

railway run psql postgresql://postgres:nOmxXsIIOmRphhCJKjVOaoDdpCgFlRnb@crossover.proxy.rlwy.net:38145/railway < backend/eradil-mufredat/config/migrations/04-hallo-remaining-activities.sql

# İzinler DB'ye de aynı şekilde
railway run psql postgresql://postgres:OgOyMbRviHkXTzukAmJsbFcfIBXKZYAH@yamanote.proxy.rlwy.net:53985/railway < backend/eradil-mufredat/config/migrations/02-izinler-schema.sql
```

**pgAdmin ile (Alternatif):**

1. Railway → Databases → digibuch_db → Connect
2. pgAdmin'de Query Tool aç
3. Her SQL dosyasını sırayla aç ve çalıştır:
   - `01-digibuch-schema.sql`
   - `03-hallo-seed-data-FIXED.sql`
   - `04-hallo-remaining-activities.sql`
4. İzinler DB için de aynı şekilde:
   - `02-izinler-schema.sql`

### ADIM 2: Backend Deploy (Render)

```bash
cd backend/eradil-mufredat

# Dependencies'leri kontrol et
npm install

# .env dosyası oluştur
cp .env.example .env

# Environment variables'ları Render Dashboard'a ekle:
DIGIBUCH_DB_URL=postgresql://postgres:nOmxXsIIOmRphhCJKjVOaoDdpCgFlRnb@crossover.proxy.rlwy.net:38145/railway
IZINLER_DB_URL=postgresql://postgres:OgOyMbRviHkXTzukAmJsbFcfIBXKZYAH@yamanote.proxy.rlwy.net:53985/railway
KULLANICI_DB_URL=postgresql://postgres:acveIHnvPDPhjXUOKFFWwmEABrvPfRWH@tramway.proxy.rlwy.net:20215/railway
ORGANIZASYON_DB_URL=postgresql://postgres:qkLOiVcCPNzgRJtcyrUBtKQWQNVTrajV@yamabiko.proxy.rlwy.net:32350/railway
JWT_SECRET=q!6tZ9dF@lW2e#hPz7yJ3kQh4@4Rm2V8gKmW1oF5pZsT9#G7vZtPzD@8Q9mF2Wz
CORS_ORIGIN=https://www.eradil.online,https://eradil.online
NODE_ENV=production
PORT=3000

# Git push to Render (otomatik deploy)
git add .
git commit -m "feat: Hallo Digibuch SQL fixed"
git push
```

### ADIM 3: Frontend Test

```bash
cd frontend

# .env'ye ekle
echo "VITE_MUFREDAT_BACKEND=https://eradil-mufredat.onrender.com/api" >> .env

# Test et
npm run dev

# Tarayıcıda aç: http://localhost:5173
# Login yap (öğrenci hesabı)
# Digibuch menüsüne git
# Hallo ünitesini aç
```

---

## ✅ KONTROL LİSTESİ

### Database
- [ ] `01-digibuch-schema.sql` çalıştırıldı (digibuch_db)
- [ ] `02-izinler-schema.sql` çalıştırıldı (izinler_db)
- [ ] `03-hallo-seed-data-FIXED.sql` çalıştırıldı (digibuch_db)
- [ ] `04-hallo-remaining-activities.sql` çalıştırıldı (digibuch_db)
- [ ] Test query çalıştı: `SELECT * FROM uniteler WHERE slug = 'hallo'` → 1 sonuç
- [ ] Test query çalıştı: `SELECT COUNT(*) FROM aktiviteler WHERE unite_id = (SELECT id FROM uniteler WHERE slug = 'hallo')` → 12 sonuç

### Backend
- [ ] Render'da servis oluşturuldu
- [ ] Environment variables eklendi
- [ ] Deploy edildi
- [ ] Health check OK: `https://eradil-mufredat.onrender.com/health`
- [ ] API test: `https://eradil-mufredat.onrender.com/api/mufredat/icerikleri/uniteler`

### Frontend
- [ ] `.env` dosyasına `VITE_MUFREDAT_BACKEND` eklendi
- [ ] `npm run dev` çalışıyor
- [ ] Digibuch menüsü görünüyor
- [ ] Hallo ünitesi listede var
- [ ] Aktiviteler açılıyor
- [ ] Tebrik modal çalışıyor

### İzinler
- [ ] Admin panelinden izin verildi VEYA
- [ ] SQL ile izin eklendi:
```sql
-- Tüm okullara izin ver
INSERT INTO mufredat_izinleri (unite_id, izin_turu, okul_id, durum)
SELECT 
    (SELECT id FROM uniteler WHERE slug = 'hallo'),
    'okul',
    id,
    'aktif'
FROM okullar;
```

---

## 🐛 SORUN ÇÖZME

### Problem: "invalid input syntax for type integer"

**Çözüm:** Eski SQL dosyalarını kullanıyorsun!
- ❌ `03-hallo-seed-data.sql` (ESKİ)
- ❌ `03-hallo-seed-data-part2.sql` (ESKİ)
- ✅ `03-hallo-seed-data-FIXED.sql` (YENİ)
- ✅ `04-hallo-remaining-activities.sql` (YENİ)

### Problem: Aktiviteler görünmüyor

**Çözüm:**
1. Backend API kontrol et: `GET /api/mufredat/icerikleri/aktiviteler/unite/:uniteId`
2. Browser console'da hata var mı?
3. İzin verildi mi kontrol et

### Problem: Sesler çalmıyor

**Çözüm:**
- Supabase Storage public mu?
- Audio URL'leri doğru mu?
- Browser autoplay policy (ilk user interaction gerekli)

---

## 📊 VERİTABANI KONTROL SORULARI

```sql
-- ✅ Hallo ünitesi var mı?
SELECT * FROM uniteler WHERE slug = 'hallo';

-- ✅ 12 aktivite var mı?
SELECT COUNT(*) FROM aktiviteler 
WHERE unite_id = (SELECT id FROM uniteler WHERE slug = 'hallo');

-- ✅ Aktiviteleri listele
SELECT 
    id,
    aktivite_id,
    tip,
    baslik,
    toplam_puan,
    sira_no,
    onceki_aktivite_id
FROM aktiviteler 
WHERE unite_id = (SELECT id FROM uniteler WHERE slug = 'hallo')
ORDER BY sira_no;

-- ✅ İlk aktivite kilit yok, diğerleri var mı?
SELECT 
    sira_no,
    baslik,
    CASE 
        WHEN onceki_aktivite_id IS NULL THEN 'KİLİTSİZ'
        ELSE 'KİLİTLİ'
    END as durum
FROM aktiviteler 
WHERE unite_id = (SELECT id FROM uniteler WHERE slug = 'hallo')
ORDER BY sira_no;
```

**Beklenen Çıktı:**
- Ünite: 1 satır (Hallo!)
- Aktivite sayısı: 12
- İlk aktivite kilit yok (onceki_aktivite_id = NULL)
- Diğer 11 aktivite kilitli (onceki_aktivite_id dolu)

---

## 🎉 BAŞARILI!

Eğer tüm checkler ✅ ise, Digibuch sistemi hazır!

### Sonraki Adımlar:
1. **İçerik Ekle:** Admin panelinden yeni üniteler/aktiviteler ekle
2. **İzin Ver:** Okul/öğretmen/sınıflara erişim izni ver
3. **Test Et:** Farklı rollerle (admin, öğretmen, öğrenci) test et
4. **Monitor Et:** Render logs ve Railway database metrics'i izle

---

**Hazırlayan:** AI Assistant  
**Tarih:** 2026-01-29  
**Versiyon:** 1.0 (FIXED)
