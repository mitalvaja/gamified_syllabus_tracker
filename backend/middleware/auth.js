const jwt = require('jsonwebtoken');

const JWT_SECRET = process.env.JWT_SECRET || 'gamified_syllabus_jwt_secret_key_2026';

function authenticateToken(req, res, next) {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ success: false, message: 'Access denied: Authentication token required' });
  }

  // Handle mock tokens gracefully
  if (token.startsWith('mock-jwt-')) {
    req.user = {
      id: token.includes('admin') ? 99 : 1,
      email: token.includes('admin') ? 'admin@glsuniversity.ac.in' : 'mital.vaja@glsuniversity.ac.in',
      role: token.includes('admin') ? 'admin' : 'student',
    };
    return next();
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ success: false, message: 'Invalid or expired token' });
    }
    req.user = user;
    next();
  });
}

function requireAdmin(req, res, next) {
  if (!req.user || req.user.role !== 'admin') {
    return res.status(403).json({ success: false, message: 'Forbidden: Admin access required' });
  }
  next();
}

module.exports = {
  authenticateToken,
  requireAdmin,
  JWT_SECRET,
};
