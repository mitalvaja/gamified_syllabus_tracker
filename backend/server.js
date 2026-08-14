const express = require('express');
const cors = require('cors');
require('dotenv').config();

const apiRoutes = require('./routes/api');

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Root & Health
app.get('/', (req, res) => {
  res.json({
    status: 'online',
    project: 'Gamified Syllabus Tracker API',
    university: 'GLS University - BCA Sem V',
    version: '1.0.0',
    documentation: '/api/subjects, /api/auth, /api/tasks, /api/quizzes',
  });
});

// API Routes
app.use('/api', apiRoutes);

// Global Error Handler
app.use((err, req, res, next) => {
  console.error('[Server Error]', err.stack);
  res.status(500).json({ success: false, message: 'Internal Server Error', error: err.message });
});

app.listen(PORT, () => {
  console.log(`=======================================================`);
  console.log(`🚀 Gamified Syllabus Tracker Server running on port ${PORT}`);
  console.log(`📡 REST API Endpoint: http://localhost:${PORT}/api`);
  console.log(`=======================================================`);
});
