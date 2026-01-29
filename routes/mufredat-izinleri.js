/**
 * MÜFREDAT İZİNLERİ ROUTES
 * Okul/Öğretmen/Sınıf bazında erişim izinleri
 * 
 * ÖNEMLİ: SADECE ADMİN İZİN ATA YABİLİR!
 * Öğretmenler sadece GÖRÜNTÜLEYEB İLİR.
 */

import express from 'express';
import { izinlerPool as pool } from '../config/database.pg.js';
import { authenticateToken, authorizeRoles } from '../middleware/auth.js';

const router = express.Router();

// ===== İZİN LİSTELEME =====

/**
 * GET / - Tüm izinleri listele
 * Erişim: Admin (atama/silme için), Öğretmen (sadece görüntüleme)
 */
router.get('/', authenticateToken, authorizeRoles('admin', 'ogretmen'), async (req, res) => {
  try {
    const { unite_id, izin_turu, okul_id, ogretmen_id, sinif_id } = req.query;

    let query = `
      SELECT * FROM mufredat_izinleri
      WHERE durum = 'aktif'
    `;
    const params = [];
    let paramIndex = 1;

    if (unite_id) {
      query += ` AND unite_id = $${paramIndex++}`;
      params.push(unite_id);
    }

    if (izin_turu) {
      query += ` AND izin_turu = $${paramIndex++}`;
      params.push(izin_turu);
    }

    if (okul_id) {
      query += ` AND okul_id = $${paramIndex++}`;
      params.push(okul_id);
    }

    if (ogretmen_id) {
      query += ` AND ogretmen_id = $${paramIndex++}`;
      params.push(ogretmen_id);
    }

    if (sinif_id) {
      query += ` AND sinif_id = $${paramIndex++}`;
      params.push(sinif_id);
    }

    query += ' ORDER BY atama_tarihi DESC';

    const { rows: izinler } = await pool.query(query, params);

    res.json({
      success: true,
      data: izinler
    });
  } catch (error) {
    console.error('İzinler listele hatası:', error);
    res.status(500).json({
      success: false,
      message: 'İzinler listelenirken hata oluştu'
    });
  }
});

/**
 * GET /ozet/:tip/:id - Belirli bir hedef için izin özeti
 * Erişim: Admin, Öğretmen
 * Örnek: GET /ozet/okul/6 -> O okulun tüm izinlerini getir
 */
router.get('/ozet/:tip/:id', authenticateToken, authorizeRoles('admin', 'ogretmen'), async (req, res) => {
  try {
    const { tip, id } = req.params;

    let view;
    let column;

    switch (tip) {
      case 'okul':
        view = 'v_okul_izin_ozeti';
        column = 'okul_id';
        break;
      case 'ogretmen':
        view = 'v_ogretmen_izin_ozeti';
        column = 'ogretmen_id';
        break;
      case 'sinif':
        view = 'v_sinif_izin_ozeti';
        column = 'sinif_id';
        break;
      default:
        return res.status(400).json({
          success: false,
          message: 'Geçersiz izin tipi. Kullanın: okul, ogretmen, sinif'
        });
    }

    const { rows: ozet } = await pool.query(`
      SELECT * FROM ${view} WHERE ${column} = $1
    `, [id]);

    if (ozet.length === 0) {
      return res.json({
        success: true,
        data: {
          toplam_unite_sayisi: 0,
          aktif_izin_sayisi: 0,
          pasif_izin_sayisi: 0,
          son_atama_tarihi: null
        }
      });
    }

    res.json({
      success: true,
      data: ozet[0]
    });
  } catch (error) {
    console.error('İzin özeti getir hatası:', error);
    res.status(500).json({
      success: false,
      message: 'İzin özeti getirilirken hata oluştu'
    });
  }
});

/**
 * GET /kontrol/:uniteId/:hedefTip/:hedefId - Belirli bir hedefin üniteye erişimi var mı?
 * Erişim: Herkes (öğrenci kontrolü için)
 * Örnek: GET /kontrol/1/okul/6 -> 6 numaralı okul 1 numaralı üniteye erişebilir mi?
 */
router.get('/kontrol/:uniteId/:hedefTip/:hedefId', authenticateToken, async (req, res) => {
  try {
    const { uniteId, hedefTip, hedefId } = req.params;

    let query;
    const params = [uniteId, hedefId];

    switch (hedefTip) {
      case 'okul':
        query = 'SELECT * FROM mufredat_izinleri WHERE unite_id = $1 AND okul_id = $2 AND durum = \'aktif\'';
        break;
      case 'ogretmen':
        query = 'SELECT * FROM mufredat_izinleri WHERE unite_id = $1 AND ogretmen_id = $2 AND durum = \'aktif\'';
        break;
      case 'sinif':
        query = 'SELECT * FROM mufredat_izinleri WHERE unite_id = $1 AND sinif_id = $2 AND durum = \'aktif\'';
        break;
      default:
        return res.status(400).json({
          success: false,
          message: 'Geçersiz hedef tip'
        });
    }

    const { rows: izinler } = await pool.query(query, params);

    res.json({
      success: true,
      erisim: izinler.length > 0,
      data: izinler.length > 0 ? izinler[0] : null
    });
  } catch (error) {
    console.error('İzin kontrol hatası:', error);
    res.status(500).json({
      success: false,
      message: 'İzin kontrol edilirken hata oluştu'
    });
  }
});

// ===== İZİN ATAMA (SADECE ADMİN) =====

/**
 * POST / - Yeni izin ata
 * Erişim: SADECE ADMİN!
 */
router.post('/', authenticateToken, authorizeRoles('admin'), async (req, res) => {
  try {
    const {
      unite_id,
      izin_turu, // 'okul', 'ogretmen', 'sinif'
      okul_id,
      ogretmen_id,
      sinif_id
    } = req.body;

    // Validasyon
    if (!unite_id || !izin_turu) {
      return res.status(400).json({
        success: false,
        message: 'unite_id ve izin_turu zorunludur'
      });
    }

    if (izin_turu === 'okul' && !okul_id) {
      return res.status(400).json({
        success: false,
        message: 'Okul izni için okul_id gereklidir'
      });
    }

    if (izin_turu === 'ogretmen' && !ogretmen_id) {
      return res.status(400).json({
        success: false,
        message: 'Öğretmen izni için ogretmen_id gereklidir'
      });
    }

    if (izin_turu === 'sinif' && !sinif_id) {
      return res.status(400).json({
        success: false,
        message: 'Sınıf izni için sinif_id gereklidir'
      });
    }

    const { rows: result } = await pool.query(`
      INSERT INTO mufredat_izinleri (
        unite_id, izin_turu, okul_id, ogretmen_id, sinif_id, atayan_admin_id
      ) VALUES ($1, $2, $3, $4, $5, $6)
      ON CONFLICT (unite_id, okul_id, ogretmen_id, sinif_id)
      DO UPDATE SET
        durum = 'aktif',
        guncelleme_tarihi = CURRENT_TIMESTAMP
      RETURNING *
    `, [
      unite_id,
      izin_turu,
      okul_id || null,
      ogretmen_id || null,
      sinif_id || null,
      req.user.id // Admin ID
    ]);

    res.status(201).json({
      success: true,
      message: 'İzin başarıyla atandı',
      data: result[0]
    });
  } catch (error) {
    console.error('İzin atama hatası:', error);
    res.status(500).json({
      success: false,
      message: 'İzin atanırken hata oluştu'
    });
  }
});

/**
 * PUT /:id - İzni güncelle (durum değiştir)
 * Erişim: SADECE ADMİN!
 */
router.put('/:id', authenticateToken, authorizeRoles('admin'), async (req, res) => {
  try {
    const { id } = req.params;
    const { durum } = req.body;

    if (!durum || !['aktif', 'pasif'].includes(durum)) {
      return res.status(400).json({
        success: false,
        message: 'Geçerli bir durum belirtin: aktif, pasif'
      });
    }

    const { rows: result } = await pool.query(`
      UPDATE mufredat_izinleri
      SET durum = $1
      WHERE id = $2
      RETURNING *
    `, [durum, id]);

    if (result.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'İzin bulunamadı'
      });
    }

    res.json({
      success: true,
      message: 'İzin durumu güncellendi',
      data: result[0]
    });
  } catch (error) {
    console.error('İzin güncelleme hatası:', error);
    res.status(500).json({
      success: false,
      message: 'İzin güncellenirken hata oluştu'
    });
  }
});

/**
 * DELETE /:id - İzni sil
 * Erişim: SADECE ADMİN!
 */
router.delete('/:id', authenticateToken, authorizeRoles('admin'), async (req, res) => {
  try {
    const { id } = req.params;

    const { rows: result } = await pool.query(`
      DELETE FROM mufredat_izinleri
      WHERE id = $1
      RETURNING *
    `, [id]);

    if (result.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'İzin bulunamadı'
      });
    }

    res.json({
      success: true,
      message: 'İzin başarıyla silindi'
    });
  } catch (error) {
    console.error('İzin silme hatası:', error);
    res.status(500).json({
      success: false,
      message: 'İzin silinirken hata oluştu'
    });
  }
});

/**
 * POST /toplu-atama - Birden fazla hedef için toplu izin atama
 * Erişim: SADECE ADMİN!
 * Body: { unite_id, hedefler: [{ izin_turu, okul_id/ogretmen_id/sinif_id }] }
 */
router.post('/toplu-atama', authenticateToken, authorizeRoles('admin'), async (req, res) => {
  try {
    const { unite_id, hedefler } = req.body;

    if (!unite_id || !Array.isArray(hedefler) || hedefler.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'unite_id ve hedefler array gereklidir'
      });
    }

    const client = await pool.connect();
    const results = [];

    try {
      await client.query('BEGIN');

      for (const hedef of hedefler) {
        const { rows: result } = await client.query(`
          INSERT INTO mufredat_izinleri (
            unite_id, izin_turu, okul_id, ogretmen_id, sinif_id, atayan_admin_id
          ) VALUES ($1, $2, $3, $4, $5, $6)
          ON CONFLICT (unite_id, okul_id, ogretmen_id, sinif_id)
          DO UPDATE SET
            durum = 'aktif',
            guncelleme_tarihi = CURRENT_TIMESTAMP
          RETURNING *
        `, [
          unite_id,
          hedef.izin_turu,
          hedef.okul_id || null,
          hedef.ogretmen_id || null,
          hedef.sinif_id || null,
          req.user.id
        ]);

        results.push(result[0]);
      }

      await client.query('COMMIT');

      res.status(201).json({
        success: true,
        message: `${results.length} izin başarıyla atandı`,
        data: results
      });
    } catch (error) {
      await client.query('ROLLBACK');
      throw error;
    } finally {
      client.release();
    }
  } catch (error) {
    console.error('Toplu izin atama hatası:', error);
    res.status(500).json({
      success: false,
      message: 'Toplu izin atanırken hata oluştu'
    });
  }
});

// ===== İZİN GEÇMİŞİ (AUDIT LOG) =====

/**
 * GET /gecmis - İzin değişiklik geçmişi
 * Erişim: SADECE ADMİN!
 */
router.get('/gecmis', authenticateToken, authorizeRoles('admin'), async (req, res) => {
  try {
    const { unite_id, admin_id, limit = 50 } = req.query;

    let query = 'SELECT * FROM izin_gecmisi WHERE 1=1';
    const params = [];
    let paramIndex = 1;

    if (unite_id) {
      query += ` AND unite_id = $${paramIndex++}`;
      params.push(unite_id);
    }

    if (admin_id) {
      query += ` AND admin_id = $${paramIndex++}`;
      params.push(admin_id);
    }

    query += ` ORDER BY islem_tarihi DESC LIMIT $${paramIndex}`;
    params.push(limit);

    const { rows: gecmis } = await pool.query(query, params);

    res.json({
      success: true,
      data: gecmis
    });
  } catch (error) {
    console.error('İzin geçmişi getir hatası:', error);
    res.status(500).json({
      success: false,
      message: 'İzin geçmişi getirilirken hata oluştu'
    });
  }
});

export default router;
