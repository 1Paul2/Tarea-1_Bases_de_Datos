// ============================================
// db.js - Conexión a SQL Server
// ============================================

const sql = require('mssql');
require('dotenv').config();

// Configuración de conexión
const config = {
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    server: process.env.DB_SERVER,
    database: process.env.DB_DATABASE,
    port: parseInt(process.env.DB_PORT) || 1433,
    options: {
        encrypt: false,
        trustServerCertificate: true,
        enableArithAbort: true
    },
    pool: {
        max: 10,
        min: 0,
        idleTimeoutMillis: 30000
    }
};

// Pool de conexiones reutilizables
const poolPromise = new sql.ConnectionPool(config)
    .connect()
    .then(pool => {
        console.log(' Conectado a SQL Server - Base:', process.env.DB_DATABASE);
        return pool;
    })
    .catch(err => {
        console.error(' Error de conexión a SQL Server:', err.message);
        process.exit(1);
    });

module.exports = { sql, poolPromise };