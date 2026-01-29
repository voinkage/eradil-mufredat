# 🐝 HALLO DIGIBUCH - İMPLEMENTASYON REHBERİ

## 📋 Genel Bakış

Bu rehber, Hallo Digibuch ünitesinin veritabanına eklenmesi ve sistemde çalıştırılması için gereken tüm adımları içerir.

## 🗄️ Veritabanı Migration'ları

### 1. Migration Dosyaları

```
config/migrations/
├── 01-digibuch-schema.sql          ✅ Ana schema (zaten çalıştırıldı)
├── 02-izinler-schema.sql           ✅ İzin sistemi (zaten çalıştırıldı)
├── 03-hallo-seed-data.sql          🆕 Hallo ünitesi + ilk 4 aktivite
└── 03-hallo-seed-data-part2.sql    🆕 Kalan 8 aktivite
```

### 2. Migration Çalıştırma Sırası

**Railway'de digibuch_db için:**

```bash
# 1. Ana schema (eğer henüz çalıştırılmadıysa)
psql -h crossover.proxy.rlwy.net -p 38145 -U postgres -d railway < 01-digibuch-schema.sql

# 2. Hallo seed data - Part 1
psql -h crossover.proxy.rlwy.net -p 38145 -U postgres -d railway < 03-hallo-seed-data.sql

# 3. Hallo seed data - Part 2
psql -h crossover.proxy.rlwy.net -p 38145 -U postgres -d railway < 03-hallo-seed-data-part2.sql
```

**Alternatif: pgAdmin veya DBeaver ile:**
1. Railway'e bağlan
2. Query Tool'u aç
3. SQL dosyasını aç ve çalıştır

## 🎯 Hallo Ünitesi İçeriği

### Ünite Bilgileri
- **Başlık:** Hallo!
- **Slug:** hallo
- **Icon:** 👋
- **Toplam Puan:** 165
- **Aktivite Sayısı:** 12

### Aktivite Listesi

| # | Tip | Başlık | Puan | Açıklama |
|---|-----|--------|------|----------|
| 1 | video | Hallo! Ich bin Buzzy! | 0 | YouTube video |
| 2 | buzzy_beezy_listen | Hör zu. | 40 | Diyalog (4 part) |
| 3 | video | Wie heißt du? | 0 | YouTube video |
| 4 | buzzy_beezy_match | Hör zu und ordnet zu. | 40 | Ses eşleştir (4 soru) |
| 5 | buzzy_beezy_audio_visual_match | Was hörst du? | 15 | Ses-görsel (4 soru) |
| 6 | buzzy_beezy_write | Schreibe Hallo oder Tschüs. | 15 | Yazma (4 soru) |
| 7 | buzzy_beezy_text_drop | Welcher Text passt? | 15 | Sürükle bırak (4 soru) |
| 8 | video | Hallo! Guten Morgen! | 0 | YouTube video |
| 9 | buzzy_beezy_text_choose | Welcher Text passt? | 15 | Metin seç (4 soru) |
| 10 | video | Wie geht es dir? | 0 | YouTube video |
| 11 | buzzy_beezy_image_order_swap | Welche Tageszeit? | 15 | Sıralama (4 görsel) |
| 12 | video | Final Video | 0 | YouTube video |

**Toplam Puanlı Aktivite:** 6 aktivite × ortalama 23 puan = **155 puan**

## 🔊 Ses Dosyaları

### Supabase Storage Yapısı

Tüm sesler Supabase Storage'da:
```
https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/audio/
├── hallo/
│   ├── instructions/
│   │   └── video-1.mp3
│   ├── etkinlik-1/ (Diyalog sesleri)
│   │   ├── etkinlik-1-sorusu.mp3
│   │   ├── diyalog-1-hallobuzzy.mp3
│   │   ├── diyalog-1-hallobezzy.mp3
│   │   └── ...
│   ├── etkinlik-2/ (Match sesleri)
│   │   ├── soru-1-dogru-cevap.mp3
│   │   ├── soru-1-yanlis-cevap.mp3
│   │   └── ...
│   ├── etkinlik-3/ (Audio Visual sesleri)
│   ├── etkinlik-4/ (Write - opsiyonel)
│   ├── etkinlik-5/ (Text Drop - opsiyonel)
│   ├── etkinlik-6/ (Text Choose - opsiyonel)
│   └── etkinlik-7/ (Image Order - opsiyonel)
```

### Frontend Ses Çalma

```javascript
// utils/audioPlayer.js kullanımı
import { playAudio } from '@/utils/audioPlayer'

// Ses objesi formatı:
const audioData = {
  storage: {
    bucket: 'audio',
    path: 'hallo/etkinlik-1/diyalog-1-hallobuzzy.mp3'
  }
}

// Ses çal
await playAudio(audioData)
```

## 🖼️ Görsel Dosyaları

### Supabase Storage Yapısı

```
https://ebmosbajxreqspmonchm.supabase.co/storage/v1/object/public/activity-assets/
├── hallo-etkinlik-1/
│   ├── arkaplan.png
│   ├── soru-ses-butonu.png
│   ├── diyalog-1-gorseli.png
│   ├── diyalog-1.png
│   ├── diyalog-1-1.png
│   └── ...
├── hallo-etkinlik-2/
├── hallo-etkinlik-3/
├── hallo-etkinlik-4/
├── hallo-etkinlik-5/
├── hallo-etkinlik-6/
└── hallo-etkinlik-7/
```

## ⚙️ Frontend Component'ler

### Tüm Component'ler Hazır ✅

```
frontend/src/components/digibuch/aktiviteler/
├── VideoAktivite.vue ✅
└── hallo/
    ├── BuzzyBeezyListen.vue ✅
    ├── BuzzyBeezyMatch.vue ✅
    ├── BuzzyBeezyAudioVisualMatch.vue ✅
    ├── BuzzyBeezyWrite.vue ✅
    ├── BuzzyBeezyTextDrop.vue ✅
    ├── BuzzyBeezyTextChoose.vue ✅
    └── BuzzyBeezyImageOrderSwap.vue ✅
```

### Ses Çalma Sistemi ✅

```javascript
// Tüm component'lerde:
import { playAudio, playSuccessSound, playErrorSound } from '@/utils/audioPlayer'

// Kullanım:
await playAudio(dialogue.audio)           // Diyalog sesi
playSuccessSound()                        // Başarı efekti
playErrorSound()                          // Hata efekti
```

## 🔐 İzin Sistemi

### İzin Verme (Admin Panelinde)

1. Admin → Digibuch → İzinler sekmesi
2. Ünite seç: "Hallo!"
3. İzin türü seç: Okul / Öğretmen / Sınıf
4. Hedef seç
5. "İzin Ver" butonuna tıkla

### SQL ile Toplu İzin

```sql
-- Tüm okullara izin ver
INSERT INTO mufredat_izinleri (unite_id, izin_turu, okul_id, durum)
SELECT 
    (SELECT id FROM uniteler WHERE slug = 'hallo'),
    'okul',
    id,
    'aktif'
FROM okullar;

-- Belirli bir sınıfa izin ver
INSERT INTO mufredat_izinleri (unite_id, izin_turu, sinif_id, durum)
VALUES (
    (SELECT id FROM uniteler WHERE slug = 'hallo'),
    'sinif',
    123, -- Sınıf ID
    'aktif'
);
```

## 🧪 Test Checklist

### Backend Test
- [ ] Migration'lar başarıyla çalıştı
- [ ] `SELECT * FROM uniteler WHERE slug = 'hallo'` → 1 sonuç
- [ ] `SELECT COUNT(*) FROM aktiviteler WHERE unite_id = (SELECT id FROM uniteler WHERE slug = 'hallo')` → 12 sonuç
- [ ] API endpoint test: `GET /api/mufredat/icerikleri/uniteler/hallo`
- [ ] API endpoint test: `GET /api/mufredat/icerikleri/aktiviteler/unite/:uniteId`

### Frontend Test
- [ ] Digibuch sayfası açılıyor (3 rol için)
- [ ] Hallo ünitesi listede görünüyor
- [ ] Ünite kartına tıklayınca detay sayfası açılıyor
- [ ] 12 aktivite görünüyor
- [ ] İlk aktivite kilitsiz, diğerleri kilitli
- [ ] Video aktivite çalışıyor (YouTube iframe)
- [ ] Diyalog aktivite çalışıyor (bubble'lar, ses butonları)
- [ ] Diğer aktiviteler açılıyor
- [ ] Aktivite tamamlandığında tebrik modal gösteriliyor
- [ ] Puan sistemi çalışıyor
- [ ] İlerleme kaydediliyor

### Ses Sistemi Test
- [ ] Diyalog sesleri çalıyor
- [ ] Yönerge sesleri çalıyor
- [ ] Bir ses çalarken diğeri başlatılınca önceki duruyor
- [ ] Ses hatası olsa bile uygulama çökm üyor

## 🚀 Deployment Adımları

### 1. Backend Deploy (Render)

```bash
cd backend/eradil-mufredat

# Environment variables Render'da ayarla:
- DIGIBUCH_DB_URL=postgresql://...
- IZINLER_DB_URL=postgresql://...
- KULLANICI_DB_URL=postgresql://...
- ORGANIZASYON_DB_URL=postgresql://...
- JWT_SECRET=...
- CORS_ORIGIN=https://www.eradil.online

# Deploy et
git push
```

### 2. Database Migration (Railway)

```bash
# Railway CLI ile veya Web UI'den SQL çalıştır
railway connect

# SQL dosyalarını çalıştır
\i 03-hallo-seed-data.sql
\i 03-hallo-seed-data-part2.sql
```

### 3. Frontend Update

Frontend zaten hazır, sadece test et!

```bash
cd frontend
npm run dev

# Test et:
- Giriş yap (öğrenci hesabı)
- Digibuch'a git
- Hallo ünitesini aç
- Aktiviteleri test et
```

### 4. İzin Ver

Admin panelinden veya SQL ile izinleri ayarla.

## 📊 Monitoring

### Kontrol Edilecekler

1. **Backend Health:**
   - `https://eradil-mufredat.onrender.com/health` → 200 OK

2. **Database Queries:**
   ```sql
   -- Ünite kontrolü
   SELECT * FROM uniteler WHERE slug = 'hallo';
   
   -- Aktivite sayısı
   SELECT COUNT(*) FROM aktiviteler WHERE unite_id = (SELECT id FROM uniteler WHERE slug = 'hallo');
   
   -- Öğrenci ilerleme
   SELECT * FROM unite_ilerlemeleri WHERE unite_id = (SELECT id FROM uniteler WHERE slug = 'hallo');
   
   -- İzinler
   SELECT * FROM mufredat_izinleri WHERE unite_id = (SELECT id FROM uniteler WHERE slug = 'hallo');
   ```

3. **Frontend Console:**
   - Hata yok
   - API çağrıları başarılı (200 OK)
   - Ses dosyaları yükleniyor

## 🐛 Troubleshooting

### Problem: Aktiviteler görünmüyor
**Çözüm:** 
- Backend API çağrısını kontrol et
- Browser console'da hata var mı bak
- Network tab'de 403/404 var mı kontrol et

### Problem: Sesler çalmıyor
**Çözüm:**
- Supabase Storage public mu kontrol et
- Audio URL'leri doğru mu kontrol et
- Browser autoplay policy'yi kontrol et (user interaction gerekli)

### Problem: İzin hatası
**Çözüm:**
- İzinler veritabanında var mı kontrol et
- `izinler_db`'de `mufredat_izinleri` tablosunu kontrol et
- API `/mufredat/izinleri/kontrol/:uniteId/:hedefTip/:hedefId` endpoint'ini test et

### Problem: İlerleme kaydedilmiyor
**Çözüm:**
- `tamamlanan_aktiviteler` tablosunu kontrol et
- `unite_ilerlemeleri` tablosunu kontrol et
- Trigger'lar çalışıyor mu kontrol et

## 📞 Destek

Sorun yaşarsan:
1. Backend logs kontrol et (Render dashboard)
2. Frontend console kontrol et (Browser DevTools)
3. Database query'leri kontrol et (Railway/pgAdmin)
4. IMPLEMENTATION_STATUS.md'yi oku

---

**Son Güncelleme:** 2026-01-29
**Hazırlayan:** AI Assistant
**Durum:** Hazır ✅
