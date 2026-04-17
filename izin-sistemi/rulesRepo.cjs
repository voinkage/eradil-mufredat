/**
 * İzinler DB — toplu kural okuma (liste filtreleme için tek sorgu)
 */

async function listRulesForOkullar (pool, okulIds) {
  if (!pool || !okulIds || okulIds.length === 0) return [];
  const { rows } = await pool.query(
    `SELECT id, icerik_turu, icerik_id, okul_id, kapsam, referans_id, izin_verildi
     FROM icerik_erisim_kurallari
     WHERE okul_id = ANY($1::bigint[])`,
    [okulIds]
  );
  return rows;
}

module.exports = { listRulesForOkullar };
