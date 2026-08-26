-- ============================================
-- DATABASE INITIALIZATION
-- ============================================

-- Eliminar la base de datos si existe
DROP DATABASE IF EXISTS datawarehouse;

-- Crear la base de datos
CREATE DATABASE datawarehouse;

-- Crear los esquemas
CREATE SCHEMA IF NOT EXISTS bronze;
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS gold;
