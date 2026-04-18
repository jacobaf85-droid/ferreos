-- ══════════════════════════════════════════════════════════════
-- FerreRH v4 — Corregir políticas RLS en todas las tablas rh_*
-- Ejecutar en: Supabase Dashboard → SQL Editor
-- Re-ejecutable: usa DROP POLICY IF EXISTS antes de cada CREATE
-- Estrategia: authenticated = acceso total (el rol se verifica en JS)
--             anon = acceso limitado para ferrecheckin.html (kiosk/celular)
-- ══════════════════════════════════════════════════════════════

-- ── rh_empleados ──────────────────────────────────────────────
ALTER TABLE public.rh_empleados ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "rh_empleados_authed" ON public.rh_empleados;
CREATE POLICY "rh_empleados_authed" ON public.rh_empleados
  FOR ALL TO authenticated USING (true) WITH CHECK (true);
-- ferrecheckin necesita leer nombre del empleado (anon)
DROP POLICY IF EXISTS "rh_empleados_anon_select" ON public.rh_empleados;
CREATE POLICY "rh_empleados_anon_select" ON public.rh_empleados
  FOR SELECT TO anon USING (true);

-- ── rh_sucursales ─────────────────────────────────────────────
ALTER TABLE public.rh_sucursales ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "rh_sucursales_authed" ON public.rh_sucursales;
CREATE POLICY "rh_sucursales_authed" ON public.rh_sucursales
  FOR ALL TO authenticated USING (true) WITH CHECK (true);
-- ferrecheckin necesita leer lat/lng/radio para validar GPS (anon)
DROP POLICY IF EXISTS "rh_sucursales_anon_select" ON public.rh_sucursales;
CREATE POLICY "rh_sucursales_anon_select" ON public.rh_sucursales
  FOR SELECT TO anon USING (true);

-- ── rh_asistencia ─────────────────────────────────────────────
ALTER TABLE public.rh_asistencia ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "rh_asistencia_authed" ON public.rh_asistencia;
CREATE POLICY "rh_asistencia_authed" ON public.rh_asistencia
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ── rh_permisos ───────────────────────────────────────────────
ALTER TABLE public.rh_permisos ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "rh_permisos_authed" ON public.rh_permisos;
CREATE POLICY "rh_permisos_authed" ON public.rh_permisos
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ── rh_prestamos ──────────────────────────────────────────────
ALTER TABLE public.rh_prestamos ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "rh_prestamos_authed" ON public.rh_prestamos;
CREATE POLICY "rh_prestamos_authed" ON public.rh_prestamos
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ── rh_contratos ──────────────────────────────────────────────
ALTER TABLE public.rh_contratos ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "rh_contratos_authed" ON public.rh_contratos;
CREATE POLICY "rh_contratos_authed" ON public.rh_contratos
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ── rh_evaluaciones ───────────────────────────────────────────
ALTER TABLE public.rh_evaluaciones ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "rh_evaluaciones_authed" ON public.rh_evaluaciones;
CREATE POLICY "rh_evaluaciones_authed" ON public.rh_evaluaciones
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ── rh_dispositivos ───────────────────────────────────────────
ALTER TABLE public.rh_dispositivos ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "rh_dispositivos_authed" ON public.rh_dispositivos;
CREATE POLICY "rh_dispositivos_authed" ON public.rh_dispositivos
  FOR ALL TO authenticated USING (true) WITH CHECK (true);
-- ferrecheckin necesita insertar/leer dispositivo sin auth (anon)
DROP POLICY IF EXISTS "rh_dispositivos_anon_ops" ON public.rh_dispositivos;
CREATE POLICY "rh_dispositivos_anon_ops" ON public.rh_dispositivos
  FOR ALL TO anon USING (true) WITH CHECK (true);

-- ── rh_checkin_logs ───────────────────────────────────────────
ALTER TABLE public.rh_checkin_logs ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "rh_checkin_logs_authed" ON public.rh_checkin_logs;
CREATE POLICY "rh_checkin_logs_authed" ON public.rh_checkin_logs
  FOR ALL TO authenticated USING (true) WITH CHECK (true);
-- ferrecheckin necesita insertar check-in y verificar duplicado (anon)
DROP POLICY IF EXISTS "rh_checkin_logs_anon_ops" ON public.rh_checkin_logs;
CREATE POLICY "rh_checkin_logs_anon_ops" ON public.rh_checkin_logs
  FOR ALL TO anon USING (true) WITH CHECK (true);

-- ── rh_enrol_tokens ───────────────────────────────────────────
ALTER TABLE public.rh_enrol_tokens ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "rh_enrol_tokens_authed" ON public.rh_enrol_tokens;
CREATE POLICY "rh_enrol_tokens_authed" ON public.rh_enrol_tokens
  FOR ALL TO authenticated USING (true) WITH CHECK (true);
-- ferrecheckin necesita leer y marcar token como usado (anon)
DROP POLICY IF EXISTS "rh_enrol_tokens_anon_select" ON public.rh_enrol_tokens;
CREATE POLICY "rh_enrol_tokens_anon_select" ON public.rh_enrol_tokens
  FOR SELECT TO anon USING (true);
DROP POLICY IF EXISTS "rh_enrol_tokens_anon_update" ON public.rh_enrol_tokens;
CREATE POLICY "rh_enrol_tokens_anon_update" ON public.rh_enrol_tokens
  FOR UPDATE TO anon USING (true) WITH CHECK (true);

-- ── rh_finiquitos ─────────────────────────────────────────────
ALTER TABLE public.rh_finiquitos ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "rh_finiquitos_authed" ON public.rh_finiquitos;
CREATE POLICY "rh_finiquitos_authed" ON public.rh_finiquitos
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ── rh_auditoria ──────────────────────────────────────────────
ALTER TABLE public.rh_auditoria ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "rh_auditoria_authed" ON public.rh_auditoria;
CREATE POLICY "rh_auditoria_authed" ON public.rh_auditoria
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ── rh_usuarios (login) ───────────────────────────────────────
ALTER TABLE public.rh_usuarios ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "rh_usuarios_authed" ON public.rh_usuarios;
CREATE POLICY "rh_usuarios_authed" ON public.rh_usuarios
  FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ══════════════════════════════════════════════════════════════
-- Verificación: mostrar todas las políticas creadas
-- ══════════════════════════════════════════════════════════════
SELECT tablename, policyname, cmd, roles
FROM pg_policies
WHERE schemaname = 'public'
  AND tablename LIKE 'rh_%'
ORDER BY tablename, policyname;
