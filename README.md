# Tarea-1 Bases de datos

## Nombre y carné de los integrantes:
 Poll Anthony Garro Vargas - 2024129001
 
## Estado del proyecto:
Completado

## Enlace del video:

# Documentación
# API REST — AdventureWorks (SQL Server + Node.js)

## 1. Introducción

Este proyecto es la solución al reto del curso **Bases de Datos II (IC4302)**, que consiste en construir una API REST que se comunique con una base de datos SQL Server (**AdventureWorks2025**) alojada en una distribución Linux, utilizando **exclusivamente Stored Procedures** para las operaciones CRUD.

La API expone endpoints para crear, leer, actualizar y eliminar productos (`Production.Product`), incluyendo dos variantes de consulta: una búsqueda sobre una sola tabla y una consulta con `JOIN` entre productos, subcategorías y categorías.

**Stack utilizado:**
- Sistema operativo: Ubuntu Server 22.04
- Motor de base de datos: SQL Server 2022 sobre Ubuntu
- Base de datos: AdventureWorks2025
- Backend: Node.js + Express
- Driver de conexión: [`mssql`](https://www.npmjs.com/package/mssql)

---

## 2. Requisitos previos

- Ubuntu (física, VM o WSL) — versión 22.04 recomendada
- Node.js 18 o superior y npm
- SQL Server para Linux instalado y corriendo
- Base de datos AdventureWorks2025 restaurada
- `sqlcmd` o una herramienta cliente (Azure Data Studio / DBeaver) para ejecutar scripts SQL

---

## 3. Instalación paso a paso

### 3.1 Instalar SQL Server en Linux

```bash
# Importar la llave del repositorio de Microsoft
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/22.04/mssql-server-2022.list | sudo tee /etc/apt/sources.list.d/mssql-server-2022.list

# Instalar el motor
sudo apt-get update
sudo apt-get install -y mssql-server

# Configurar (contraseña de SA, edición, etc.)
sudo /opt/mssql/bin/mssql-conf setup

# Verificar que el servicio esté activo
systemctl status mssql-server
```

Instalar las herramientas de línea de comandos (`sqlcmd`):

```bash
curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
sudo apt-get update
sudo apt-get install -y mssql-tools18 unixodbc-dev
echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc
source ~/.bashrc
```

### 3.2 Restaurar la base de datos AdventureWorks2025

```bash
sqlcmd -S localhost -U sa -P '<tu_password>' -C -Q "
RESTORE DATABASE AdventureWorks2025
FROM DISK = '/ruta/al/backup/AdventureWorks2025.bak'
WITH MOVE 'AdventureWorks2025' TO '/var/opt/mssql/data/AdventureWorks2025.mdf',
     MOVE 'AdventureWorks2025_log' TO '/var/opt/mssql/data/AdventureWorks2025_log.ldf';"
```

### 3.3 Crear los Stored Procedures

Ejecutar el script `sql/stored_procedures.sql` incluido en este repositorio (contiene los 5 SPs: insert, update, delete, select simple y select con join):

```bash
sqlcmd -S localhost -U sa -P '<tu_password>' -C -d AdventureWorks2025 -i sql/stored_procedures.sql
```

### 3.4 Instalar Node.js y dependencias del proyecto

```bash
# Instalar Node.js (via NodeSource, ejemplo para v18)
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Clonar el repositorio e instalar dependencias
git clone <url-de-tu-repositorio>
cd <carpeta-del-proyecto>
npm install
```

---

## 4. Configuración del servicio

Crear un archivo `.env` en la raíz del proyecto:

```env
DB_USER=sa
DB_PASSWORD=<tu_password>
DB_SERVER=localhost
DB_DATABASE=AdventureWorks2025
DB_PORT=1433
PORT=3000
```

Levantar el servidor:

```bash
npm start
```

Si la conexión es correcta, la consola debe mostrar:

```
Conectado a SQL Server - Base: AdventureWorks2025
Servidor corriendo en http://localhost:3000
```

---

## 5. Documentación de la API

| Método | Endpoint                          | Descripción                                  | Stored Procedure               |
|--------|------------------------------------|-----------------------------------------------|---------------------------------|
| GET    | `/api/products/search?name=...`   | Busca productos por nombre (una tabla)        | `usp_GetProductsByName`         |
| GET    | `/api/products/with-category`     | Lista productos con su categoría (JOIN)       | `usp_GetProductsWithCategory`   |
| POST   | `/api/products`                   | Crea un producto nuevo                        | `usp_InsertProduct`             |
| PUT    | `/api/products/:id`               | Actualiza campos de un producto existente     | `usp_UpdateProduct`             |
| DELETE | `/api/products/:id`               | Elimina un producto y sus registros asociados | `usp_DeleteProduct`             |

### Ejemplos de cuerpo de petición

**POST /api/products**
```json
{
  "name": "Mountain Bike Nueva",
  "productNumber": "MB-9999",
  "listPrice": 899.99
}
```

**PUT /api/products/999** 
```json
{
  "color": "Red",
  "listPrice": 950.00
}
```

---

## 6. Datos de prueba

Productos usados para probar el CRUD durante el desarrollo:

| ProductID | Name                  | ProductNumber | ListPrice | Uso en la prueba                          |
|-----------|-----------------------|---------------|-----------|--------------------------------------------|
| 707       | Sport-100 Helmet, Red | HL-U509-R     | 34.99     | GET /search y GET /with-category (producto que ya existe en AdventureWorks2025) |
| 999       | Mountain Bike Nueva   | MB-9999       | 899.99    | POST -> luego PUT (cambiar color/precio) -> luego DELETE |

## 7. Referencias

- Creating REST API for reading data from Microsoft SQL Server in web browser — [tomaztsql.wordpress.com](https://tomaztsql.wordpress.com/2021/08/10/creating-rest-api-for-reading-data-from-microsoft-sql-server-in-web-browser/)
- How to quickly create a simple REST API for SQL Server database — [Medium / Vooban's Tech Stories](https://medium.com/voobans-tech-stories/how-to-quickly-create-a-simple-rest-api-for-sql-server-database-7ddb595f751a)
- AdventureWorks sample databases — [GitHub / Microsoft SQL Server Samples](https://github.com/Microsoft/sql-server-samples/releases/tag/adventureworks)

