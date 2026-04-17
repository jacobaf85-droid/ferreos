# PENDIENTES_FUTUROS.md
Ideas y mejoras detectadas durante ejecución — no bloquean el piloto.
Revisar después del rollout en Calzada/Yamir.

---

## [UX] Primer render de Empleados muestra "0" antes de que syncFromCloud termine

**Síntoma:** Al hacer login, la vista de Empleados muestra "0 empleados" durante ~1-2s hasta
que `syncFromCloud()` termina y `renderHome()` vuelve a ejecutarse.

**Causa:** `doLogin()` llama `renderHome()` y luego `syncFromCloud()` sin `await`. El primer
render usa `emp=[]` (localStorage vacío en sesión fresca). Un F5 lo resuelve porque
localStorage ya tiene los datos del sync anterior.

**Opciones de fix (cuando se retome):**
1. `await syncFromCloud()` antes de `renderHome()` en `doLogin` — bloquea el login ~1s pero
   garantiza datos en primer render. Requiere mostrar spinner mientras espera.
2. Al final de `syncFromCloud()` (tras `renderHome()`), emitir un evento o llamar
   `renderVista(currentTab)` para re-renderizar solo la vista activa sin recargar todo.
3. Skeleton/placeholder en `renderEmpleados()` cuando `emp.length===0 && syncing===true`.

**Prioridad:** Baja — solo visible en primera sesión del día (o incógnito). No afecta datos.
