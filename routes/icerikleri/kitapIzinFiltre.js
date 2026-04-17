/**
 * İçerik izinleri (IZINLER_DB) — öğrenci/öğretmen kitap listesi ve detay
 */
import { createRequire } from 'module';

const require = createRequire(import.meta.url);
const { loadErisimCtx, listRulesForOkullar, canSeeIcerik } = require('../../izin-sistemi');

/**
 * IZINLER_DB yoksa tüm satırlar; varsa okul/sınıf/öğretmen kurallarına göre süzülür.
 */
export async function filtreKitaplarForUser (rows, user, { kullaniciPool, organizasyonPool, izinlerPool }) {
  if (!izinlerPool) return rows;
  const ctx = await loadErisimCtx(user, { kullaniciPool, organizasyonPool });
  if (!ctx.okul_ids?.length) return [];
  const rules = await listRulesForOkullar(izinlerPool, ctx.okul_ids);
  return rows.filter((k) => canSeeIcerik(ctx, 'kitap', k.id, rules));
}

export async function kitapErisimIzniVar (kitapId, user, { kullaniciPool, organizasyonPool, izinlerPool }) {
  if (!izinlerPool) return true;
  const ctx = await loadErisimCtx(user, { kullaniciPool, organizasyonPool });
  if (!ctx.okul_ids?.length) return false;
  const rules = await listRulesForOkullar(izinlerPool, ctx.okul_ids);
  return canSeeIcerik(ctx, 'kitap', kitapId, rules);
}
