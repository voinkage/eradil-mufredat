/**
 * ÜNİTELER ROUTE
 * Ünite CRUD işlemleri
 */

import express from 'express';
import { digibuchPool as pool } from '../../config/database.pg.js';
import { authenticateToken, authorizeRoles } from '../../middleware/auth.js';

const router = express.Router();

/**
 * GET / - Tüm üniteleri listele
 * Erişim: Herkes (auth gerekli)
 * İzin kontrolü: Öğrenci sadece kendisine izin verilmiş üniteleri görür
 */
router.get('/', authenticateToken, async (req, res) => {
  try {
    // Admin/Öğretmen tüm üniteleri görebilir
    if (req.user.rol === 'admin' || req.user.rol === 'ogretmen') {
      const { rows: uniteler } = await pool.query(`
        SELECT 
          id, baslik, aciklama, slug, icon,
          kapak_gorseli, sira_no, durum, toplam_puan
        FROM uniteler
        WHERE durum = 'aktif'
        ORDER BY sira_no ASC
      `);

      return res.json({
        success: true,
        data: uniteler
      });
    }

    // Öğrenci için izin kontrolü
    // İzinler ayrı bir veritabanında (izinler_db)
    // Geçici olarak tüm üniteleri döndür (izin sistemi sonra eklenecek)
    const { rows: uniteler } = await pool.query(`
      SELECT 
        id, baslik, aciklama, slug, icon,
        kapak_gorseli, sira_no, durum, toplam_puan
      FROM uniteler
      WHERE durum = 'aktif'
      ORDER BY sira_no ASC
    `);

    res.json({
      success: true,
      data: uniteler,
      message: 'İzin kontrolü henüz aktif değil - tüm üniteler gösteriliyor'
    });
  } catch (error) {
    console.error('Üniteler listele hatası:', error);
    res.status(500).json({
      success: false,
      message: 'Üniteler listelenirken hata oluştu'
    });
  }
});

/**
 * GET /:slug - Belirli bir üniteyi getir
 * Erişim: Herkes (auth gerekli)
 */
router.get('/:slug', authenticateToken, async (req, res) => {
  try {
    const { slug } = req.params;

    const { rows: uniteler } = await pool.query(`
      SELECT * FROM uniteler WHERE slug = $1 AND durum = 'aktif'
    `, [slug]);

    if (uniteler.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Ünite bulunamadı'
      });
    }

    res.json({
      success: true,
      data: uniteler[0]
    });
  } catch (error) {
    console.error('Ünite getir hatası:', error);
    res.status(500).json({
      success: false,
      message: 'Ünite getirilirken hata oluştu'
    });
  }
});

/**
 * POST / - Yeni ünite oluştur
 * Erişim: Sadece admin
 */
router.post('/', authenticateToken, authorizeRoles('admin'), async (req, res) => {
  try {
    const {
      baslik,
      aciklama,
      slug,
      icon,
      kapak_gorseli,
      arkaplan_gorseli,
      sira_no,
      toplam_puan
    } = req.body;

    const { rows: result } = await pool.query(`
      INSERT INTO uniteler (
        baslik, aciklama, slug, icon, kapak_gorseli, 
        arkaplan_gorseli, sira_no, toplam_puan, olusturan_id
      ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
      RETURNING *
    `, [
      baslik,
      aciklama,
      slug,
      icon,
      kapak_gorseli,
      arkaplan_gorseli,
      sira_no || 0,
      toplam_puan || 0,
      req.user.id
    ]);

    res.status(201).json({
      success: true,
      message: 'Ünite başarıyla oluşturuldu',
      data: result[0]
    });
  } catch (error) {
    console.error('Ünite oluşturma hatası:', error);
    res.status(500).json({
      success: false,
      message: error.code === '23505' 
        ? 'Bu slug zaten kullanılıyor' 
        : 'Ünite oluşturulurken hata oluştu'
    });
  }
});

/**
 * PUT /:id - Üniteyi güncelle
 * Erişim: Sadece admin
 */
router.put('/:id', authenticateToken, authorizeRoles('admin'), async (req, res) => {
  try {
    const { id } = req.params;
    const {
      baslik,
      aciklama,
      slug,
      icon,
      kapak_gorseli,
      arkaplan_gorseli,
      sira_no,
      toplam_puan,
      durum
    } = req.body;

    const { rows: result } = await pool.query(`
      UPDATE uniteler SET
        baslik = COALESCE($1, baslik),
        aciklama = COALESCE($2, aciklama),
        slug = COALESCE($3, slug),
        icon = COALESCE($4, icon),
        kapak_gorseli = COALESCE($5, kapak_gorseli),
        arkaplan_gorseli = COALESCE($6, arkaplan_gorseli),
        sira_no = COALESCE($7, sira_no),
        toplam_puan = COALESCE($8, toplam_puan),
        durum = COALESCE($9, durum)
      WHERE id = $10
      RETURNING *
    `, [baslik, aciklama, slug, icon, kapak_gorseli, arkaplan_gorseli, sira_no, toplam_puan, durum, id]);

    if (result.length === 0) {
      return res.status(404).json({
        success: false,
        message: 'Ünite bulunamadı'
      });
    }

    res.json({
      success: true,
      message: 'Ünite başarıyla güncellendi',
      data: result[0]
    });
  } catch (error) {
    console.error('Ünite güncelleme hatası:', error);
    res.status(500).json({
      success: false,
      message: 'Ünite güncellenirken hata oluştu'
    });
  }
});

/**
 * DELETE /:id - Üniteyi sil
 * Erişim: Sadece admin
 */
router.delete('/:id', authenticateToken, authorizeRoles('admin'), async (req, res) => {
  try {
    const { id } = req.params;

    await pool.query('DELETE FROM uniteler WHERE id = $1', [id]);

    res.json({
      success: true,
      message: 'Ünite başarıyla silindi'
    });
  } catch (error) {
    console.error('Ünite silme hatası:', error);
    res.status(500).json({
      success: false,
      message: 'Ünite silinirken hata oluştu'
    });
  }
});

export default router;
