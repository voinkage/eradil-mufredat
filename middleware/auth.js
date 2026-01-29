/**
 * AUTH MIDDLEWARE
 * JWT token doğrulama ve rol bazlı yetkilendirme
 */

import jwt from 'jsonwebtoken';

/**
 * JWT Token doğrulama
 */
export const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({
      success: false,
      message: 'Token bulunamadı'
    });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(403).json({
      success: false,
      message: 'Geçersiz token'
    });
  }
};

/**
 * Rol bazlı yetkilendirme
 * @param  {...string} allowedRoles - İzin verilen roller (örn: 'admin', 'ogretmen', 'ogrenci')
 */
export const authorizeRoles = (...allowedRoles) => {
  return (req, res, next) => {
    if (!req.user || !req.user.rol) {
      return res.status(403).json({
        success: false,
        message: 'Rol bilgisi bulunamadı'
      });
    }

    if (!allowedRoles.includes(req.user.rol)) {
      return res.status(403).json({
        success: false,
        message: 'Bu işlem için yetkiniz yok'
      });
    }

    next();
  };
};
