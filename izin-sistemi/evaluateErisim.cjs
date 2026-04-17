/**
 * Okul bazlı içerik kuralları — tek içerik + ilgili okul(lar) için satırlar
 * (.cjs — package.json "type":"module" ile uyumlu)
 */
function evaluateErisim (rules, ctx) {
  const okulAcik = rules.some((r) => r.kapsam === 'okul' && r.izin_verildi === true);
  if (!okulAcik) return false;

  const rol = ctx.rol;
  if (rol === 'ogrenci') {
    const closed = new Set(
      rules
        .filter((r) => r.kapsam === 'sinif' && r.izin_verildi === false)
        .map((r) => Number(r.referans_id))
    );
    let ids = Array.isArray(ctx.sinif_ids) ? [...ctx.sinif_ids] : [];
    if (ids.length === 0 && ctx.sinif_id != null) ids = [Number(ctx.sinif_id)];
    const hasSinifRules = rules.some((r) => r.kapsam === 'sinif');
    if (ids.length === 0) {
      return !hasSinifRules;
    }
    return ids.some((sid) => !closed.has(Number(sid)));
  }

  if (rol === 'ogretmen') {
    const uid = Number(ctx.kullanici_id);
    const ogretmenKapali = rules.some(
      (r) =>
        r.kapsam === 'ogretmen' &&
        Number(r.referans_id) === uid &&
        r.izin_verildi === false
    );
    if (ogretmenKapali) return false;
  }

  return true;
}

function canSeeIcerik (ctx, icerikTuru, icerikId, rules) {
  const iid = Number(icerikId);
  const tur = String(icerikTuru).toLowerCase();
  const itemRules = rules.filter(
    (r) => String(r.icerik_turu).toLowerCase() === tur && Number(r.icerik_id) === iid
  );
  if (!ctx.okul_ids || ctx.okul_ids.length === 0) return false;

  return ctx.okul_ids.some((okulId) => {
    const perOkul = itemRules.filter((r) => Number(r.okul_id) === Number(okulId));
    let sinif_ids = ctx.sinif_ids || [];
    if (ctx.rol === 'ogrenci' && ctx.sinifToOkul && typeof ctx.sinifToOkul.get === 'function') {
      sinif_ids = sinif_ids.filter((sid) => Number(ctx.sinifToOkul.get(sid)) === Number(okulId));
    }
    return evaluateErisim(perOkul, {
      rol: ctx.rol,
      kullanici_id: ctx.kullanici_id,
      sinif_ids
    });
  });
}

module.exports = { evaluateErisim, canSeeIcerik };
