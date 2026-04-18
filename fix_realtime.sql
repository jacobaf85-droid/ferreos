-- ══════════════════════════════════════════════════════════════
-- FerreRH v4 — Habilitar Realtime en todas las tablas rh_*
-- Ejecutar en: Supabase Dashboard → SQL Editor
-- Re-ejecutable: el bloque DO maneja duplicados sin error
-- ══════════════════════════════════════════════════════════════

DO $$
DECLARE
  tbls TEXT[] := ARRAY[
    'rh_empleados',
    'rh_sucursales',
    'rh_asistencia',
    'rh_permisos',
    'rh_prestamos',
    'rh_contratos',
    'rh_evaluaciones',
    'rh_dispositivos',
    'rh_checkin_logs',
    'rh_enrol_tokens',
    'rh_finiquitos'
  ];
  t TEXT;
BEGIN
  FOREACH t IN ARRAY tbls LOOP
    BEGIN
      EXECUTE 'ALTER PUBLICATION supabase_realtime ADD TABLE public.' || quote_ident(t);
      RAISE NOTICE 'OK: % agregada a supabase_realtime', t;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'SKIP: % (ya estaba o no existe): %', t, SQLERRM;
    END;
  END LOOP;
END $$;

-- Verificar qué tablas quedaron en la publicación:
SELECT tablename
FROM pg_publication_tables
WHERE pubname = 'supabase_realtime'
  AND schemaname = 'public'
  AND tablename LIKE 'rh_%'
ORDER BY tablename;
