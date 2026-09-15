# Tarea-1 Bases de datos

## Nombre y carné de los integrantes:
Poll Anthony Garro Vargas - 2024129001

## Estado del proyecto:
Completado

## Enlace del video:
[URL del video en YouTube - público]

---

# Documentación
# API REST - AdventureWorks - SQL Server + Node.js

## 1. Introducción

Este proyecto es la solución al reto del curso **Bases de Datos II (IC4302)**, que consiste en construir una API REST que se comunique con una base de datos SQL Server (**AdventureWorks2025**) alojada en una distribución Linux, utilizando **exclusivamente Stored Procedures** para las operaciones CRUD.

La API expone endpoints para crear, leer, actualizar y eliminar departamentos (`HumanResources.Department`), incluyendo dos variantes de consulta: una búsqueda sobre una sola tabla y una consulta con `JOIN` entre departamentos, historial de departamentos de empleados y empleados.

**Stack utilizado:**
- Sistema operativo: Ubuntu 24.04.4 LTS
- Motor de base de datos: SQL Server 2025 sobre Ubuntu
- Base de datos: AdventureWorks2025
- Backend: Node.js + Express
- Driver de conexión: mssql

---

## 2. Requisitos previos

- Ubuntu (física, VM o WSL) — versión 22.04 o superior
- Node.js 18 o superior y npm
- SQL Server para Linux instalado y corriendo
- Base de datos AdventureWorks2025 restaurada
- sqlcmd o VS Code con extensión MSSQL para ejecutar scripts SQL

---

## 3. Instalación paso a paso

### 3.1 Instalar SQL Server en Linux

    curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
    curl https://packages.microsoft.com/config/ubuntu/24.04/mssql-server-2025.list | sudo tee /etc/apt/sources.list.d/mssql-server-2025.list
    sudo apt-get update
    sudo apt-get install -y mssql-server
    sudo /opt/mssql/bin/mssql-conf setup
    systemctl status mssql-server

Instalar sqlcmd:

    curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
    curl https://packages.microsoft.com/config/ubuntu/24.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
    sudo apt-get update
    sudo apt-get install -y mssql-tools18 unixodbc-dev
    echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
    source ~/.bashrc

> Nota: el flag -C en sqlcmd es necesario para aceptar el certificado autofirmado del servidor (ODBC Driver 18+).

### 3.2 Restaurar la base de datos AdventureWorks2025

Descargar el backup:

    cd ~/Downloads
    wget https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2025.bak

Mover el archivo:

    sudo mkdir -p /var/opt/mssql/backup
    sudo mv ~/Downloads/AdventureWorks2025.bak /var/opt/mssql/backup/
    sudo chown mssql:mssql /var/opt/mssql/backup/AdventureWorks2025.bak
    sudo chmod 640 /var/opt/mssql/backup/AdventureWorks2025.bak

Verificar nombres logicos:

    sqlcmd -S localhost -U sa -P '<tu_password>' -C -Q "RESTORE FILELISTONLY FROM DISK='/var/opt/mssql/backup/AdventureWorks2025.bak'"

Restaurar:

    sqlcmd -S localhost -U sa -P '<tu_password>' -C -Q "
    RESTORE DATABASE AdventureWorks2025
    FROM DISK = '/var/opt/mssql/backup/AdventureWorks2025.bak'
    WITH MOVE 'AdventureWorks' TO '/var/opt/mssql/data/AdventureWorks2025.mdf',
         MOVE 'AdventureWorks_log' TO '/var/opt/mssql/data/AdventureWorks2025_log.ldf',
         REPLACE, STATS = 10;"

### 3.3 Crear los Stored Procedures

Los 5 Stored Procedures estan en la carpeta `Script sql/Codigos_sql/`:

| # | Archivo | Stored Procedure | Operacion CRUD |
|---|---------|------------------|----------------|
| 1 | INSERT.sql | usp_InsertDepartment | Create |
| 2 | UPDATE.sql | usp_UpdateDepartment | Update |
| 3 | DELETE.sql | usp_DeleteDepartment | Delete |
| 4 | SELECT.sql | usp_GetDepartmentsByName | Read (una tabla) |
| 5 | SELECT_with_JOIN.sql | usp_GetDepartmentsWithEmployees | Read (con JOIN) |

Ejecutar cada archivo en VS Code con la extension MSSQL, conectado a `SQL local | AdventureWorks2025`, presionando Ctrl + Shift + E.

### 3.4 Instalar Node.js y dependencias

    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
    node -v
    npm -v
    git clone <url-de-tu-repositorio>
    cd Tarea-1_Bases_de_Datos/codigo
    npm install

---

## 4. Configuracion del servicio

Crear un archivo `.env` dentro de la carpeta `codigo/`:

    DB_USER=sa
    DB_PASSWORD=<tu_password>
    DB_SERVER=localhost
    DB_DATABASE=AdventureWorks2025
    DB_PORT=1433
    PORT=3000

Levantar el servidor:

    cd codigo
    npm start

Salida esperada:

    =============================================
    API corriendo en http://localhost:3000
    Endpoints en http://localhost:3000/
    =============================================
    Conectado a SQL Server - Base: AdventureWorks2025

---

## 5. Documentacion de la API

| Metodo | Endpoint | Descripcion | Stored Procedure |
|--------|----------|-------------|------------------|
| GET | / | Health check: lista los endpoints disponibles | (ninguno) |
| GET | /api/departments/search?name=... | Busca departamentos por nombre (una tabla) | usp_GetDepartmentsByName |
| GET | /api/departments/with-employees | Lista departamentos con sus empleados (JOIN) | usp_GetDepartmentsWithEmployees |
| POST | /api/departments | Crea un departamento nuevo | usp_InsertDepartment |
| PUT | /api/departments/:id | Actualiza un departamento existente | usp_UpdateDepartment |
| DELETE | /api/departments/:id | Elimina un departamento | usp_DeleteDepartment |

### Ejemplos de cuerpo de peticion

POST /api/departments

    {
      "name": "Video Demo",
      "groupName": "Testing"
    }

PUT /api/departments/:id

    {
      "name": "Video Demo Updated",
      "groupName": "QA Updated"
    }

---

## 6. Datos de prueba

Departamentos usados para probar el CRUD:

| DepartmentID | Name | GroupName | Uso en la prueba |
|--------------|------|-----------|------------------|
| 1 | Engineering | Research and Development | GET /search (busca "Engineering") |
| 3 | Sales | Sales and Marketing | GET /with-employees (JOIN con empleados) |
| 19 | Video Demo | Testing | POST -> PUT -> DELETE (ciclo CRUD completo) |

Resultados esperados durante las pruebas:

1. GET /api/departments/search?name=Engineering -> devuelve 1 resultado.
2. GET /api/departments/with-employees -> devuelve ~290 filas (empleados con su departamento).
3. POST /api/departments -> devuelve NewDepartmentID (por ejemplo, 19).
4. PUT /api/departments/19 -> devuelve RowsAffected: 1.
5. DELETE /api/departments/19 -> devuelve RowsAffected: 1.
6. GET /api/departments/search?name=Video Demo Updated -> devuelve total: 0 (ya no existe).

---

## 7. Estructura del repositorio

    Tarea-1_Bases_de_Datos/
    ├── codigo/
    │   ├── .env
    │   ├── .gitignore
    │   ├── package.json
    │   ├── package-lock.json
    │   ├── db.js
    │   ├── server.js
    │   ├── routes/
    │   │   └── departments.js
    │   └── README.md
    ├── Script sql/Codigos_sql/
    │   ├── INSERT.sql
    │   ├── UPDATE.sql
    │   ├── DELETE.sql
    │   ├── SELECT.sql
    │   └── SELECT_with_JOIN.sql
    ├── proyectos/
    │   └── README.md
    └── README.md

---

## 8. Referencias

- Creating REST API for reading data from Microsoft SQL Server in web browser — tomaztsql.wordpress.com
- How to quickly create a simple REST API for SQL Server database — Medium / Vooban's Tech Stories
- AdventureWorks sample databases — GitHub / Microsoft SQL Server Samples
