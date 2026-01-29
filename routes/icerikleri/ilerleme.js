/**
 * İLERLEME ROUTE
 * Öğrenci ilerleme durumu ve aktivite tamamlama
 */

import express from 'express';
import { digibuchPool as pool } from '../../config/database.pg.js';
import { authenticateToken, authorizeRoles } from '../../middleware/auth.js';

const router = express.Router();

/**
 * GET / - Öğrencinin tüm ilerleme durumu
 * Erişim: Öğrenci (kendi) veya admin
 */
router.get('/', authenticateToken, async (req, res) => {
  try {
    const ogrenciId = req.user.rol === 'admin' && req.query.ogrenci_id 
      ? req.query.ogrenci_id 
      : req.user.id;

    const { rows: ilerleme } = await pool.query(`
      SELECT 
        ui.*,
        u.baslik as unite_baslik,
        u.slug as unite_slug,
        u.toplam_puan as unite_toplam_puan,
        u.kapak_gorseli as unite_kapak_gorseli
      FROM unite_ilerlemeleri ui
      JOIN uniteler u ON ui.unite_id = u.id
      WHERE ui.ogrenci_id = $1
      ORDER BY u.sira_no ASC
    `, [ogrenciId]);

    res.json({
      success: true,
      data: ilerleme
    });
  } catch (error) {
    console.error('İlerleme getir hatası:', error);
    res.status(500).json({
      success: false,
      message: 'İlerleme getirilirken hata oluştu'
    });
  }
});

/**
 * GET /unite/:uniteId - Belirli ünite için ilerleme
 * Erişim: Öğrenci (kendi) veya admin
 */
router.get('/unite/:uniteId', authenticateToken, async (req, res) => {
  try {
    const { uniteId } = req.params;
    const ogrenciId = req.user.rol === 'admin' && req.query.ogrenci_id 
      ? req.query.ogrenci_id 
      : req.user.id;

    const { rows: ilerleme } = await pool.query(`
      SELECT 
        ui.*,
        u.baslik as unite_baslik,
        u.slug as unite_slug
      FROM unite_ilerlemeleri ui
      JOIN uniteler u ON ui.unite_id = u.id
      WHERE ui.ogrenci_id = $1 AND ui.unite_id = $2
    `, [ogrenciId, uniteId]);

    if (ilerleme.length === 0) {
      return res.json({
        success: true,
        data: {
          ogrenci_id: ogrenciId,
          unite_id: uniteId,
          tamamlanan_aktivite_sayisi: 0,
          kazanilan_puan: 0
        }
      });
    }

    res.json({
      success: true,
      data: ilerleme[0]
    });
  } catch (error) {
    console.error('Ünite ilerleme getir hatası:', error);
    res.status(500).json({
      success: false,
      message: 'Ünite ilerleme getirilirken hata oluştu'
    });
  }
});

/**
 * GET /tamamlanan - Öğrencinin tamamladığı aktiviteler
 * Erişim: Öğrenci (kendi) veya admin
 */
router.get('/tamamlanan', authenticateToken, async (req, res) => {
  try {
    const ogrenciId = req.user.rol === 'admin' && req.query.ogrenci_id 
      ? req.query.ogrenci_id 
      : req.user.id;

    const { unite_id } = req.query;

    let query = `
      SELECT 
        ta.*,
        a.baslik as aktivite_baslik,
        a.tip as aktivite_tip,
        u.baslik as unite_baslik
      FROM tamamlanan_aktiviteler ta
      JOIN aktiviteler a ON ta.aktivite_id = a.id
      JOIN uniteler u ON ta.unite_id = u.id
      WHERE ta.ogrenci_id = $1
    `;
    const params = [ogrenciId];

    if (unite_id) {
      query += ' AND ta.unite_id = $2';
      params.push(unite_id);
    }

    query += ' ORDER BY ta.tamamlanma_tarihi DESC';

    const { rows: tamamlanan } = await pool.query(query, params);

    res.json({
      success: true,
      data: tamamlanan
    });
  } catch (error) {
    console.error('Tamamlanan aktiviteler getir hatası:', error);
    res.status(500).json({
      success: false,
      message: 'Tamamlanan aktiviteler getirilirken hata oluştu'
    });
  }
});

/**
 * POST /tamamla/:aktiviteId - Aktiviteyi tamamla
 * Erişim: Öğrenci
 */
router.post('/tamamla/:aktiviteId', authenticateToken, authorizeRoles('ogrenci'), async (req, res) => {
  try {
    const { aktiviteId } = req.params;
    const { kazanilan_puan, detay } = req.body;
    const ogrenciId = req.user.id;

    // Aktivite bilgisini al
    const { rows: aktiviteler } = await pool.query(
      'SELECT * FROM aktiviteler WHERE id = $1',
      [aktiviteId]
    );

    if (aktiviteler.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Aktivite bulunamadı'
      });
    }

    const aktivite = aktiviteler[0];

    // Tamamlandı olarak kaydet (veya güncelle)
    const { rows: result } = await pool.query(`
      INSERT INTO tamamlanan_aktiviteler (
        ogrenci_id, unite_id, aktivite_id, kazanilan_puan, detay
      ) VALUES ($1, $2, $3, $4, $5)
      ON CONFLICT (ogrenci_id, aktivite_id)
      DO UPDATE SET
        kazanilan_puan = GREATEST(tamamlanan_aktiviteler.kazanilan_puan, $4),
        detay = $5,
        tamamlanma_tarihi = CURRENT_TIMESTAMP
      RETURNING *
    `, [
      ogrenciId, 
      aktivite.unite_id, 
      aktiviteId, 
      kazanilan_puan || 0, 
      detay ? JSON.stringify(detay) : null
    ]);

    res.json({
      success: true,
      message: 'Aktivite başarıyla tamamlandı! 🎉',
      data: result[0]
    });
  } catch (error) {
    console.error('Aktivite tamamlama hatası:', error);
    res.status(500).json({
      success: false,
      message: 'Aktivite tamamlanırken hata oluştu'
    });
  }
});

/**
 * GET /aktivite-durum/:aktiviteId - Belirli aktivitenin tamamlanma durumu
 * Erişim: Öğrenci (kendi)
 */
router.get('/aktivite-durum/:aktiviteId', authenticateToken, async (req, res) => {
  try {
    const { aktiviteId } = req.params;
    const ogrenciId = req.user.id;

    const { rows: tamamlanan } = await pool.query(`
      SELECT * FROM tamamlanan_aktiviteler
      WHERE ogrenci_id = $1 AND aktivite_id = $2
    `, [ogrenciId, aktiviteId]);

    res.json({
      success: true,
      tamamlandi: tamamlanan.length > 0,
      data: tamamlanan.length > 0 ? tamamlanan[0] : null
    });
  } catch (error) {
    console.error('Aktivite durum kontrol hatası:', error);
    res.status(500).json({
      success: false,
      message: 'Aktivite durum kontrol edilirken hata oluştu'
    });
  }
});

export default router;
