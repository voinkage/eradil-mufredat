/**
 * JWT kullanıcısı için okul / sınıf bağlamı (izin değerlendirmesi)
 */

async function loadErisimCtx (user, { kullaniciPool, organizasyonPool }) {
  const rol = user.rol || user.role;
  const uid = Number(user.id);
  if (Number.isNaN(uid)) {
    return { rol: rol || 'unknown', kullanici_id: 0, okul_ids: [], sinif_ids: [], sinifToOkul: new Map() };
  }

  if (rol === 'ogretmen') {
    if (!kullaniciPool) {
      return { rol, kullanici_id: uid, okul_ids: [], sinif_ids: [], sinifToOkul: new Map() };
    }
    const { rows } = await kullaniciPool.query(
      'SELECT okul_id FROM kullanicilar WHERE id = $1',
      [uid]
    );
    const oid = rows[0]?.okul_id != null ? Number(rows[0].okul_id) : null;
    return {
      rol,
      kullanici_id: uid,
      okul_ids: oid != null ? [oid] : [],
      sinif_ids: [],
      sinifToOkul: new Map()
    };
  }

  if (rol === 'ogrenci') {
    if (!organizasyonPool) {
      return { rol, kullanici_id: uid, okul_ids: [], sinif_ids: [], sinifToOkul: new Map() };
    }
    const { rows } = await organizasyonPool.query(
      `SELECT s.id AS sinif_id, s.okul_id
       FROM ogrenci_sinif os
       INNER JOIN siniflar s ON s.id = os.sinif_id
       WHERE os.ogrenci_id = $1
         AND os.bag_durum = 'aktif'
         AND (s.durum = 'aktif' OR s.durum IS NULL)`,
      [uid]
    );
    const sinifToOkul = new Map();
    for (const r of rows) {
      if (r.sinif_id != null && r.okul_id != null) {
        sinifToOkul.set(Number(r.sinif_id), Number(r.okul_id));
      }
    }
    const sinif_ids = [...sinifToOkul.keys()];
    const okul_ids = [...new Set([...sinifToOkul.values()])];
    return { rol, kullanici_id: uid, okul_ids, sinif_ids, sinifToOkul };
  }

  return { rol: rol || 'unknown', kullanici_id: uid, okul_ids: [], sinif_ids: [], sinifToOkul: new Map() };
}

module.exports = { loadErisimCtx };
