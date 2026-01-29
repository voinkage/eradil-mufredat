/**
 * AKTİVİTELER ROUTE
 * Aktivite CRUD işlemleri
 */

import express from 'express';
import { digibuchPool as pool } from '../../config/database.pg.js';
import { authenticateToken, authorizeRoles } from '../../middleware/auth.js';

const router = express.Router();

/**
 * GET /unite/:uniteId - Üniteye ait aktiviteleri listele
 * Erişim: Herkes (auth gerekli)
 */
router.get('/unite/:uniteId', authenticateToken, async (req, res) => {
  try {
    const { uniteId } = req.params;

    const { rows: aktiviteler } = await pool.query(`
      SELECT 
        id, unite_id, aktivite_id, tip, baslik,
        icerik, arkaplan_gorseli, yonerge_ses, video_url,
        ui_butonlar, toplam_puan, sira_no, onceki_aktivite_id, durum
      FROM aktiviteler
      WHERE unite_id = $1 AND durum = 'aktif'
      ORDER BY sira_no ASC
    `, [uniteId]);

    res.json({
      success: true,
      data: aktiviteler
    });
  } catch (error) {
    console.error('Aktiviteler listele hatası:', error);
    res.status(500).json({
      success: false,
      message: 'Aktiviteler listelenirken hata oluştu'
    });
  }
});

/**
 * GET /:id - Belirli bir aktiviteyi getir
 * Erişim: Herkes (auth gerekli)
 */
router.get('/:id', authenticateToken, async (req, res) => {
  try {
    const { id } = req.params;

    const { rows: aktiviteler } = await pool.query(`
      SELECT * FROM aktiviteler WHERE id = $1 AND durum = 'aktif'
    `, [id]);

    if (aktiviteler.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Aktivite bulunamadı'
      });
    }

    res.json({
      success: true,
      data: aktiviteler[0]
    });
  } catch (error) {
    console.error('Aktivite getir hatası:', error);
    res.status(500).json({
      success: false,
      message: 'Aktivite getirilirken hata oluştu'
    });
  }
});

/**
 * POST / - Yeni aktivite oluştur
 * Erişim: Sadece admin
 */
router.post('/', authenticateToken, authorizeRoles('admin'), async (req, res) => {
  try {
    const {
      unite_id,
      aktivite_id,
      tip,
      baslik,
      icerik,
      arkaplan_gorseli,
      yonerge_ses,
      video_url,
      ui_butonlar,
      toplam_puan,
      sira_no,
      onceki_aktivite_id
    } = req.body;

    const { rows: result } = await pool.query(`
      INSERT INTO aktiviteler (
        unite_id, aktivite_id, tip, baslik, icerik,
        arkaplan_gorseli, yonerge_ses, video_url, ui_butonlar,
        toplam_puan, sira_no, onceki_aktivite_id
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
      RETURNING *
    `, [
      unite_id,
      aktivite_id,
      tip,
      baslik,
      typeof icerik === 'string' ? icerik : JSON.stringify(icerik),
      arkaplan_gorseli,
      yonerge_ses ? (typeof yonerge_ses === 'string' ? yonerge_ses : JSON.stringify(yonerge_ses)) : null,
      video_url,
      ui_butonlar ? (typeof ui_butonlar === 'string' ? ui_butonlar : JSON.stringify(ui_butonlar)) : null,
      toplam_puan || 0,
      sira_no || 0,
      onceki_aktivite_id
    ]);

    res.status(201).json({
      success: true,
      message: 'Aktivite başarıyla oluşturuldu',
      data: result[0]
    });
  } catch (error) {
    console.error('Aktivite oluşturma hatası:', error);
    res.status(500).json({
      success: false,
      message: 'Aktivite oluşturulurken hata oluştu',
      error: process.env.NODE_ENV === 'development' ? error.message : undefined
    });
  }
});

/**
 * PUT /:id - Aktiviteyi güncelle
 * Erişim: Sadece admin
 */
router.put('/:id', authenticateToken, authorizeRoles('admin'), async (req, res) => {
  try {
    const { id } = req.params;
    const updates = { ...req.body };

    // JSON alanları stringify et (eğer obje ise)
    if (updates.icerik && typeof updates.icerik === 'object') {
      updates.icerik = JSON.stringify(updates.icerik);
    }
    if (updates.yonerge_ses && typeof updates.yonerge_ses === 'object') {
      updates.yonerge_ses = JSON.stringify(updates.yonerge_ses);
    }
    if (updates.ui_butonlar && typeof updates.ui_butonlar === 'object') {
      updates.ui_butonlar = JSON.stringify(updates.ui_butonlar);
    }

    const fields = Object.keys(updates).map((key, index) => `${key} = $${index + 1}`);
    const values = Object.values(updates);

    if (fields.length === 0) {
      return res.status(400).json({
        success: false,
        message: 'Güncellenecek alan bulunamadı'
      });
    }

    const { rows: result } = await pool.query(`
      UPDATE aktiviteler SET ${fields.join(', ')}
      WHERE id = $${values.length + 1}
      RETURNING *
    `, [...values, id]);

    if (result.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Aktivite bulunamadı'
      });
    }

    res.json({
      success: true,
      message: 'Aktivite başarıyla güncellendi',
      data: result[0]
    });
  } catch (error) {
    console.error('Aktivite güncelleme hatası:', error);
    res.status(500).json({
      success: false,
      message: 'Aktivite güncellenirken hata oluştu'
    });
  }
});

/**
 * DELETE /:id - Aktiviteyi sil
 * Erişim: Sadece admin
 */
router.delete('/:id', authenticateToken, authorizeRoles('admin'), async (req, res) => {
  try {
    const { id } = req.params;

    await pool.query('DELETE FROM aktiviteler WHERE id = $1', [id]);

    res.json({
      success: true,
      message: 'Aktivite başarıyla silindi'
    });
  } catch (error) {
    console.error('Aktivite silme hatası:', error);
    res.status(500).json({
      success: false,
      message: 'Aktivite silinirken hata oluştu'
    });
  }
});

export default router;
