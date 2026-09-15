// ============================================
// routes/departments.js - Endpoints REST para departamentos
// ============================================

const express = require('express');
const router = express.Router();
const { sql, poolPromise } = require('../db');

// ============================================
// CREATE - POST /api/departments
// Llama a: usp_InsertDepartment
// ============================================
router.post('/', async (req, res) => {
    try {
        const { name, groupName } = req.body;

        if (!name || !groupName) {
            return res.status(400).json({
                error: 'Faltan campos: name, groupName'
            });
        }

        const pool = await poolPromise;
        const result = await pool.request()
            .input('Name', sql.NVarChar(50), name)
            .input('GroupName', sql.NVarChar(50), groupName)
            .execute('usp_InsertDepartment');

        res.status(201).json({
            mensaje: 'Departamento insertado correctamente',
            data: result.recordset
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// ============================================
// UPDATE - PUT /api/departments/:id
// Llama a: usp_UpdateDepartment
// ============================================
router.put('/:id', async (req, res) => {
    try {
        const { id } = req.params;
        const { name, groupName } = req.body;

        if (!name || !groupName) {
            return res.status(400).json({ error: 'Faltan campos: name, groupName' });
        }

        const pool = await poolPromise;
        const result = await pool.request()
            .input('DepartmentID', sql.SmallInt, parseInt(id))
            .input('Name', sql.NVarChar(50), name)
            .input('GroupName', sql.NVarChar(50), groupName)
            .execute('usp_UpdateDepartment');

        res.json({
            mensaje: 'Departamento actualizado',
            data: result.recordset
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// ============================================
// DELETE - DELETE /api/departments/:id
// Llama a: usp_DeleteDepartment
// ============================================
router.delete('/:id', async (req, res) => {
    try {
        const { id } = req.params;

        const pool = await poolPromise;
        const result = await pool.request()
            .input('DepartmentID', sql.SmallInt, parseInt(id))
            .execute('usp_DeleteDepartment');

        res.json({
            mensaje: 'Departamento eliminado',
            data: result.recordset
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// ============================================
// READ (una tabla) - GET /api/departments/search?name=X
// Llama a: usp_GetDepartmentsByName
// ============================================
router.get('/search', async (req, res) => {
    try {
        const name = req.query.name || '';

        const pool = await poolPromise;
        const result = await pool.request()
            .input('Name', sql.NVarChar(50), name)
            .execute('usp_GetDepartmentsByName');

        res.json({
            total: result.recordset.length,
            data: result.recordset
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// ============================================
// READ con JOIN - GET /api/departments/with-employees
// Llama a: usp_GetDepartmentsWithEmployees
// ============================================
router.get('/with-employees', async (req, res) => {
    try {
        const pool = await poolPromise;
        const result = await pool.request()
            .execute('usp_GetDepartmentsWithEmployees');

        res.json({
            total: result.recordset.length,
            data: result.recordset
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

module.exports = router;