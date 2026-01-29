# 🎓 ERADIL MÜFREDAT (DIGIBUCH) BACKEND

Dijital müfredat sistemi - İlerlemeli öğrenme platformu backend servisi.

---

## 📊 Genel Bakış

**Port:** `3004`  
**Database:** PostgreSQL (Railway)  
**Frontend:** Vue.js 3

### İki Ayrı Database:

1. **`digibuch_db`** - Müfredat içerikleri (uniteler, aktiviteler, oyunlar, ilerleme)
2. **`izinler_db`** - Erişim izinleri (okul/öğretmen/sınıf bazında)

---

## 🚀 Kurulum

### 1. Dependencies Yükle
```bash
cd backend/eradil-mufredat
npm install
```

### 2. Environment Variables
`.env` dosyası oluştur (`.env.example`'dan kopyala):
```bash
cp .env.example .env
```

Önemli değişkenler:
- `PORT=3004`
- `JWT_SECRET` (diğer backend'lerle aynı!)
- `DIGIBUCH_DB_URL` (Railway PostgreSQL)
- `IZINLER_DB_URL` (Railway PostgreSQL)

### 3. Database Migration
`config/migrations/` klasöründeki SQL dosyalarını Railway pgAdmin'de çalıştır:
1. `01-digibuch-schema.sql` → digibuch_db
2. `02-izinler-schema.sql` → izinler_db

Detaylar: `config/migrations/README.md`

### 4. Başlat
```bash
# Development
npm run dev

# Production
npm start
```

---

## 📡 API Endpoints

### Health Check
```
GET /health
```

### İçerik Yönetimi (`/api/mufredat/icerikleri`)

#### Üniteler
- `GET /uniteler` - Tüm üniteleri listele
- `GET /uniteler/:slug` - Belirli üniteyi getir
- `POST /uniteler` - Yeni ünite oluştur (Admin)
- `PUT /uniteler/:id` - Ünite güncelle (Admin)
- `DELETE /uniteler/:id` - Ünite sil (Admin)

#### Aktiviteler
- `GET /uniteler/:uniteId/aktiviteler` - Ünite aktivitelerini listele
- `GET /aktiviteler/:id` - Belirli aktiviteyi getir
- `POST /aktiviteler` - Yeni aktivite oluştur (Admin)
- `PUT /aktiviteler/:id` - Aktivite güncelle (Admin)
- `DELETE /aktiviteler/:id` - Aktivite sil (Admin)

#### İlerleme (Öğrenci)
- `GET /ilerleme` - Öğrencinin ilerleme durumu
- `POST /aktiviteler/:id/tamamla` - Aktiviteyi tamamla (Öğrenci)

### İzin Yönetimi (`/api/mufredat/izinleri`)

#### Listeleme (Admin + Öğretmen)
- `GET /` - Tüm izinleri listele
- `GET /ozet/:tip/:id` - İzin özeti (okul/ogretmen/sinif)
- `GET /kontrol/:uniteId/:hedefTip/:hedefId` - Erişim kontrolü

#### Atama (SADECE ADMİN!)
- `POST /` - Yeni izin ata
- `POST /toplu-atama` - Toplu izin atama
- `PUT /:id` - İzni güncelle
- `DELETE /:id` - İzni sil

#### Geçmiş (SADECE ADMİN!)
- `GET /gecmis` - İzin değişiklik geçmişi

---

## 🔐 Yetkilendirme

### Roller
- **Admin:** Tüm işlemler (içerik + izin yönetimi)
- **Öğretmen:** Sadece görüntüleme
- **Öğrenci:** Sadece kendi ilerleme + aktivite tamamlama

### İzin Hiyerarşisi
1. **Okul İzni:** Tüm okula erişim → Okuldaki tüm öğretmen/öğrenciler erişebilir
2. **Öğretmen İzni:** Sadece o öğretmene erişim
3. **Sınıf İzni:** Sadece o sınıftaki öğrencilere erişim

---

## 📊 Database Şeması

### `digibuch_db`

**uniteler** - Müfredat üniteleri
```sql
id, baslik, slug, aciklama, icon, kapak_gorseli, 
arkaplan_gorseli, sira_no, toplam_puan, durum
```

**aktiviteler** - Ünite aktiviteleri
```sql
id, unite_id, aktivite_id, tip, baslik, icerik (JSONB),
arkaplan_gorseli, yonerge_ses (JSONB), video_url,
ui_butonlar (JSONB), toplam_puan, sira_no, durum
```

**tamamlanan_aktiviteler** - Öğrenci tamamlamaları
```sql
id, ogrenci_id, unite_id, aktivite_id,
tamamlandi, kazanilan_puan, detay (JSONB), tamamlanma_tarihi
```

**unite_ilerlemeleri** - İlerleme özeti
```sql
id, ogrenci_id, unite_id, tamamlanan_aktivite_sayisi,
kazanilan_puan, son_aktivite_id, son_erisim_tarihi
```

### `izinler_db`

**mufredat_izinleri** - İzin atamaları
```sql
id, unite_id, izin_turu, okul_id, ogretmen_id, sinif_id,
durum, atayan_admin_id, atama_tarihi
```

**izin_gecmisi** - Değişiklik log'u
```sql
id, islem, unite_id, izin_turu, admin_id, 
eski_durum (JSONB), yeni_durum (JSONB), islem_tarihi
```

---

## 🛠️ Geliştirme Notları

### Aktivite Tipleri (Enum)
```
- video
- buzzy_beezy_listen
- buzzy_beezy_match
- buzzy_beezy_audio_visual_match
- buzzy_beezy_write
- buzzy_beezy_text_drop
- buzzy_beezy_text_choose
- buzzy_beezy_image_order_swap
```

### JSON İçerik Formatı
`aktiviteler.icerik` JSONB olarak saklanır. Örnek yapı:
```json
{
  "questions": [...],
  "parts": [...],
  "images": [...],
  "textOptions": [...]
}
```

### Trigger'lar
- Aktivite tamamlandığında `unite_ilerlemeleri` otomatik güncellenir
- İzin değişiklikleri otomatik log'lanır (`izin_gecmisi`)

---

## 📝 Örnek İstekler

### Üniteler
```bash
# Tüm üniteleri listele
GET /api/mufredat/icerikleri/uniteler
Authorization: Bearer <token>

# "Hallo" ünitesini getir
GET /api/mufredat/icerikleri/uniteler/hallo
Authorization: Bearer <token>
```

### İzin Atama (Admin)
```bash
# Okul bazında izin
POST /api/mufredat/izinleri
Authorization: Bearer <admin-token>
Content-Type: application/json

{
  "unite_id": 1,
  "izin_turu": "okul",
  "okul_id": 6
}

# Toplu atama
POST /api/mufredat/izinleri/toplu-atama
{
  "unite_id": 1,
  "hedefler": [
    { "izin_turu": "okul", "okul_id": 6 },
    { "izin_turu": "sinif", "sinif_id": 10 }
  ]
}
```

### Aktivite Tamamlama (Öğrenci)
```bash
POST /api/mufredat/icerikleri/aktiviteler/1/tamamla
Authorization: Bearer <ogrenci-token>

{
  "kazanilan_puan": 15,
  "detay": {
    "dogru_sayisi": 4,
    "yanlis_sayisi": 0,
    "sure": 120
  }
}
```

---

## 🚨 Önemli Notlar

1. **Sadece Admin İzin Atayabilir:**
   - Öğretmenler izin **atayamaz**, sadece **görüntüleyebilir**
   - Backend `authorizeRoles('admin')` ile kontrol edilir

2. **JWT Secret:**
   - Tüm backend servislerde **aynı** `JWT_SECRET` kullanılmalı
   - Token'lar `eradil-kullanici` servisi tarafından üretilir

3. **Cross-Database Queries:**
   - İzin kontrolü için `kullanici_db` ve `organizasyon_db` ile iletişim gerekebilir
   - HTTP request ile `KULLANICI_BACKEND_URL` kullanılacak

4. **JSONB Kullanımı:**
   - Aktivite içerikleri esnek yapı için JSONB kullanır
   - Hızlı sorgulama için index'lenebilir

---

## 📦 Deployment (Render)

1. Render'da yeni Web Service oluştur
2. GitHub repo bağla: `backend/eradil-mufredat`
3. Build Command: `npm install`
4. Start Command: `npm start`
5. Environment Variables ekle (`.env.example`'dan)
6. Database URL'lerini doğrula (Railway PostgreSQL)
7. Deploy!

**Service URL:** `https://eradil-mufredat.onrender.com`

---

## ✅ Durum

- [x] Backend yapısı oluşturuldu
- [x] Database şemaları hazır
- [x] API route'ları tamamlandı
- [x] Auth middleware entegre
- [x] Migration dosyaları hazır
- [ ] Frontend entegrasyonu (TODO)
- [ ] Render deployment

---

## 👨‍💻 Geliştirici

**ERAX Eğitim Teknolojileri**  
Backend: Node.js + Express + PostgreSQL  
Frontend: Vue.js 3

---

**Not:** Frontend kısmı için `frontend/src/views/digibuch/` klasörü oluşturulacak.
