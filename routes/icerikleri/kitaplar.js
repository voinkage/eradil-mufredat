/**
 * ERADIL-MÜFREDAT – Öğrenci/öğretmen için kitap listesi ve detay (çözüm ekranı)
 * Admin listesi ve CRUD erax-admin'de (/api/mufredat/icerikleri/kitaplar).
 */
import express from 'express';
import { digibuchPool as pool } from '../../config/database.pg.js';
import { authenticateToken, authorizeRoles } from '../../middleware/auth.js';

const router = express.Router();

/** GET / - Öğrenci/öğretmen: kitap listesi. Öğrenci için sadece aktif. */
router.get('/', authenticateToken, authorizeRoles('ogrenci', 'ogretmen'), async (req, res) => {
  try {
    const userRol = req.user.rol || req.user.role;
    const isOgrenci = userRol === 'ogrenci';
    const whereClause = isOgrenci ? " WHERE k.durum = 'aktif'" : '';
    const { rows } = await pool.query(`
      SELECT k.*, (SELECT COUNT(*)::int FROM kitap_sorulari WHERE kitap_id = k.id) AS soru_sayisi
      FROM kitaplar k${whereClause}
      ORDER BY k.id DESC
    `);
    return res.json({ success: true, data: rows });
  } catch (error) {
    console.error('Kitaplar listele hatası:', error);
    return res.status(500).json({ success: false, message: 'Kitaplar listelenirken hata oluştu' });
  }
});

/** GET /:id - Öğrenci/öğretmen: kitap detayı + sorular (çözüm ekranı) */
router.get('/:id', authenticateToken, authorizeRoles('ogrenci', 'ogretmen'), async (req, res) => {
  try {
    const { id } = req.params;
    const { rows: kitaplar } = await pool.query('SELECT * FROM kitaplar WHERE id = $1', [id]);
    if (kitaplar.length === 0) {
      return res.status(404).json({ success: false, message: 'Kitap bulunamadı' });
    }

    const { rows: sorularRaw } = await pool.query(
      `SELECT * FROM kitap_sorulari WHERE kitap_id = $1 ORDER BY soru_numarasi`,
      [id]
    );

    const sorular = await Promise.all(sorularRaw.map(async (soru) => {
      const { rows: seceneklerRaw } = await pool.query(
        `SELECT id, secenek_metni, secenek_gorseli, secenek_ses_dosyasi, secenek_rengi, kategori, dogru_cevap, siralama
         FROM kitap_soru_secenekleri WHERE soru_id = $1 ORDER BY siralama`,
        [soru.id]
      );
      const secenekler = seceneklerRaw.map(s => ({
        id: s.id,
        secenek_metni: s.secenek_metni || null,
        secenek_gorseli: s.secenek_gorseli || null,
        secenek_ses_dosyasi: s.secenek_ses_dosyasi || null,
        secenek_rengi: s.secenek_rengi || null,
        metin: s.secenek_metni || null,
        gorsel: s.secenek_gorseli || null,
        renk: s.secenek_rengi || null,
        kategori: s.kategori || null,
        dogru_cevap: s.dogru_cevap || 0,
        dogru: s.dogru_cevap || 0,
        siralama: s.siralama || 0
      }));

      const isAsamali = !!(soru.asamali === true || soru.asamali === 't' || soru.asamali === 'true' || soru.asamali === 1 || soru.asamali === '1');
      let asamalar = [];
      if (isAsamali) {
        let asamalarRaw = [];
        try {
          const r = await pool.query(
            'SELECT id, asama_numarasi, icerik FROM kitap_soru_asamalari WHERE soru_id = $1 ORDER BY asama_numarasi',
            [soru.id]
          );
          asamalarRaw = r.rows || [];
        } catch {
          asamalarRaw = [];
        }
        asamalar = asamalarRaw.map(a => {
          let icerik = a.icerik;
          if (typeof icerik === 'string') {
            try { icerik = JSON.parse(icerik) || {}; } catch { icerik = {}; }
          }
          return { asama_numarasi: a.asama_numarasi, icerik: icerik || {} };
        });
      }
      return { ...soru, asamali: isAsamali, secenekler, asamalar };
    }));

    const kitapData = { ...kitaplar[0], soru_sayisi: sorular.length };
    if (sorular.length > 0 && !kitapData.tur) kitapData.tur = sorular[0].soru_turu;

    return res.json({
      success: true,
      data: { etkinlik: kitapData, sorular }
    });
  } catch (error) {
    console.error('Kitap detay hatası:', error);
    return res.status(500).json({ success: false, message: 'Kitap bilgileri alınırken hata oluştu' });
  }
});

export default router;
