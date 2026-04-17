-- ============================================================
-- FERRERH v4 — AUDIT_SUPABASE.sql
-- Auditoría Fase 0.1 — Estado real del backend
-- Ejecutar en Supabase SQL Editor (xqezbplfwubddwsbobhi)
-- Proyecto: rrhhftpops.netlify.app
-- Generado: 2026-04-17
-- ============================================================
-- INSTRUCCIONES:
--   Ejecutar cada bloque por separado (seleccionar y Run).
--   Copiar los resultados de cada query y compartirlos para análisis.
-- ============================================================


-- ============================================================
-- A. ESTRUCTURA DE TABLAS
--    Verifica que las tablas rh_* existen y sus columnas exactas.
--    Buscar: columnas faltantes, tipos incorrectos, nulabilidad inesperada.
-- ============================================================
SELECT
  table_name,
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name LIKE 'rh_%'
ORDER BY table_name, ordinal_position;


-- ============================================================
-- B. RLS — ROW LEVEL SECURITY
--    Verifica qué tablas tienen RLS activo y qué políticas existen.
--    Buscar: tablas sin RLS, policies demasiado permisivas (USING(true) para anon).
-- ============================================================

-- B1. Estado de RLS por tabla
SELECT
  tablename,
  rowsecurity
FROM pg_tables
WHERE schemaname = 'public'
  AND tablename LIKE 'rh_%'
ORDER BY tablename;

-- B2. Políticas existentes (detalle completo)
SELECT
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename LIKE 'rh_%'
ORDER BY tablename, policyname;


-- ============================================================
-- C. TRIGGERS EN rh_checkin_logs
--    Verifica si existe trigger que genere fecha/hora server-side.
--    Si el resultado está vacío → el trigger NO existe (bug crítico).
-- ============================================================
SELECT
  trigger_name,
  event_manipulation,
  action_timing,
  action_statement
FROM information_schema.triggers
WHERE event_object_schema = 'public'
  AND event_object_table = 'rh_checkin_logs'
ORDER BY trigger_name;


-- ============================================================
-- D. STORAGE — BUCKETS Y POLICIES
--    Verifica que los buckets existen y tienen la visibilidad correcta.
--    checkin-selfies debe ser public=true
--    rh-documentos debe ser public=false
-- ============================================================

-- D1. Buckets
SELECT
  id,
  name,
  public,
  created_at
FROM storage.buckets
WHERE id IN ('checkin-selfies', 'rh-documentos');

-- D2. Políticas de Storage
SELECT
  name,
  bucket_id,
  operation,
  definition
FROM storage.policies
WHERE bucket_id IN ('checkin-selfies', 'rh-documentos')
ORDER BY bucket_id, name;


-- ============================================================
-- E. GPS — COORDENADAS DE SUCURSALES
--    Identifica sucursales sin lat/lng/radio configurados.
--    Si hay filas → el check-in GPS puede pasar sin validar (bug crítico).
-- ============================================================
SELECT
  id,
  nombre,
  lat,
  lng,
  radio
FROM rh_sucursales
WHERE lat IS NULL
   OR lng IS NULL
   OR radio IS NULL
ORDER BY nombre;

-- Complementario: ver TODAS las sucursales con sus coordenadas actuales
SELECT
  id,
  nombre,
  lat,
  lng,
  radio
FROM rh_sucursales
ORDER BY nombre;


-- ============================================================
-- F. INCONSISTENCIA rh_asistencia vs rh_incidencias
--    El código escribe a rh_asistencia pero lee de rh_incidencias.
--    Necesitamos saber cuántos registros tiene cada tabla para decidir
--    cuál conservar y si hay que migrar datos.
-- ============================================================

-- F1. Conteo de registros en ambas tablas
SELECT 'rh_incidencias' AS tabla, COUNT(*) AS total FROM rh_incidencias
UNION ALL
SELECT 'rh_asistencia'  AS tabla, COUNT(*) AS total FROM rh_asistencia;

-- F2. Muestra de los primeros 5 registros de rh_incidencias (ver estructura real)
SELECT * FROM rh_incidencias ORDER BY id LIMIT 5;

-- F3. Muestra de los primeros 5 registros de rh_asistencia (ver estructura real)
SELECT * FROM rh_asistencia ORDER BY id LIMIT 5;

-- F4. Verificar si las columnas de ambas tablas son compatibles para migración
SELECT
  table_name,
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name IN ('rh_incidencias', 'rh_asistencia')
ORDER BY table_name, ordinal_position;


-- ============================================================
-- G. EXTRA — VERIFICACIÓN DE TABLAS REQUERIDAS POR EL SISTEMA
--    Confirma que todas las tablas que el código espera existen.
--    Las que NO aparezcan en el resultado → deben crearse antes del piloto.
-- ============================================================
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_name IN (
    'rh_empleados',
    'rh_sucursales',
    'rh_incidencias',
    'rh_asistencia',
    'rh_permisos',
    'rh_prestamos',
    'rh_contratos',
    'rh_evaluaciones',
    'rh_dispositivos',
    'rh_checkin_logs',
    'rh_enrol_tokens',
    'rh_finiquitos',
    'rh_usuarios'
  )
ORDER BY table_name;
