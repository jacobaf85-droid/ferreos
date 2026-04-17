# PREGUNTAS_JACOB.md
Dudas surgidas durante ejecución — responder antes del piloto.

---

## [TAREA B] Archivos huérfanos en bucket rh-documentos

El bucket `rh-documentos` fue convertido a privado. Tiene 2 archivos cuyas URLs
públicas ya no funcionan.

**Acción necesaria por Jacob:**
1. En Supabase SQL Editor, ejecutar:
   ```sql
   SELECT name, created_at, metadata FROM storage.objects
   WHERE bucket_id = 'rh-documentos'
   ORDER BY created_at;
   ```
2. Si los archivos son de prueba (creados antes del 17-abr-2026 o nombre genérico):
   - Confirmar y borrar desde el Storage Explorer de Supabase.
3. Si son documentos reales (contratos firmados, etc.):
   - Generar signed URLs con 1 año de expiración desde Supabase Dashboard
     (Storage → rh-documentos → archivo → "Create signed URL" → 31536000 segundos)
   - Actualizar la referencia en la tabla correspondiente (probablemente
     `rh_contratos.firma_url` o campo similar) con la nueva signed URL.

**Decisión pendiente:** ¿Son archivos de prueba o producción?
