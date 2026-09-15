// ============================================
// server.js - Servidor principal de la API
// ============================================

const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();

// Middlewares
app.use(cors());
app.use(express.json());

// Ruta raíz de bienvenida
app.get('/', (req, res) => {
    res.json({
        mensaje: 'API REST - AdventureWorks2025 - Departamentos',
        version: '1.0.0',
        endpoints: {
            insertar: 'POST /api/departments',
            actualizar: 'PUT /api/departments/:id',
            eliminar: 'DELETE /api/departments/:id',
            buscarPorNombre: 'GET /api/departments/search?name=X',
            buscarConJoin: 'GET /api/departments/with-employees'
        }
    });
});

// Rutas de departamentos
app.use('/api/departments', require('./routes/departments'));

// Arranque del servidor
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log('=============================================');
    console.log(`API corriendo en http://localhost:${PORT}`);
    console.log(`Endpoints en http://localhost:${PORT}/`);
    console.log('=============================================');
});