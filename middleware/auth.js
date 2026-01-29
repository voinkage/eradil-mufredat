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
    
    // Debug: Token içeriğini logla
    console.log('🔑 JWT Token decoded:', {
      id: decoded.id,
      userId: decoded.userId,
      user_id: decoded.user_id,
      rol: decoded.rol,
      kullanici_adi: decoded.kullanici_adi
    });
    
    // req.user'a kaydet
    req.user = decoded;
    
    // Eğer user.id yoksa ama user_id veya userId varsa düzelt
    if (!req.user.id && (req.user.user_id || req.user.userId)) {
      req.user.id = req.user.user_id || req.user.userId;
      console.log('⚠️ user.id düzeltildi:', req.user.id);
    }
    
    // Hala yoksa hata
    if (!req.user.id || req.user.id === 'temp') {
      console.error('❌ Token\'da geçerli user ID yok:', decoded);
      return res.status(403).json({
        success: false,
        message: 'Token\'da geçerli kullanıcı ID\'si bulunamadı'
      });
    }
    
    next();
  } catch (error) {
    console.error('❌ JWT doğrulama hatası:', error.message);
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
