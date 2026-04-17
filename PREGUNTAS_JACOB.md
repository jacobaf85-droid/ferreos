# PREGUNTAS_JACOB.md
Dudas surgidas durante ejecución — responder antes del piloto.

---

## ~~[TAREA B] Archivos huérfanos en bucket rh-documentos~~ ✅ CERRADA — 17-abr-2026

Los 2 PNGs huérfanos fueron eliminados manualmente desde Supabase Storage.
Único objeto restante: `firmas/emp1/.emptyFolderPlaceholder` (0 bytes, placeholder
automático de Supabase — no requiere acción).

**Corrección de código aplicada:** `subirArchivoRH()` en `ferreh_v4.html` usaba
`getPublicUrl()` (inservible con bucket privado). Cambiado a `createSignedUrl()`
con 1 año de expiración (31 536 000 s). Commit: `docs(rh): close Tarea B...`
