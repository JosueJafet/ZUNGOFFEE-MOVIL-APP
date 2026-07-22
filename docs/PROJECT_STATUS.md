# Zungoffee Mobile — Estado del Proyecto

> Documento vivo. Objetivo: que cualquier desarrollador (o una futura sesión
> de IA) pueda retomar el proyecto exactamente desde este punto sin perder
> contexto. Actualizar este archivo al cerrar cada Sprint.

Última actualización: cierre de Sprint 1 (Task 1 y Task 2), previo a la pausa
del desarrollo.

---

## Información general

- **Nombre del proyecto:** Zungofee Mobile (paquete Dart: `zungofee_mobile`).
- **Objetivo:** aplicación móvil empresarial para gestión de bodega de café
  ("Zungoffee Mobile — Enterprise Mobile Application for Coffee Warehouse
  Management", según `pubspec.yaml`). Debe verse y comportarse como la misma
  identidad de producto que el panel web existente (misma paleta, tipografía
  y jerarquía de componentes).
- **Estado actual:** infraestructura base (Sprint 0, 0.5 y Sprint 1 — Tasks 1
  y 2) completada y aprobada. **Desarrollo pausado** a la espera del backend
  oficial (ver sección "Información importante").
- **Plataforma objetivo:** Android. El proyecto también contiene el
  scaffolding de `ios/` generado por `flutter create`, pero el foco de
  desarrollo declarado es Android.
- **Arquitectura utilizada:** Clean Architecture por *feature*, con
  separación `data/` (`datasources`, `dtos`, `models`, `repositories`) y
  `presentation/` (`providers`, `screens`, `widgets`) dentro de cada módulo
  de negocio, más una capa `core/` (infraestructura transversal) y `shared/`
  (elementos reutilizables entre features). Ver detalle en "Estructura
  actual del proyecto".
- **Tecnologías aprobadas** (declaradas en `pubspec.yaml`):
  - **Flutter / Dart:** SDK Dart `>=3.3.0 <4.0.0`; toolchain resuelto con
    Flutter `>=3.35.6` / Dart `>=3.9.0` (`pubspec.lock`).
  - **Gestión de estado:** `flutter_riverpod ^2.5.1`.
  - **Cliente HTTP:** `dio ^5.4.3` (declarado; aún no implementado).
  - **Navegación:** `go_router ^14.2.0` (implementado en Sprint 1 — Task 2).
  - **Almacenamiento seguro:** `flutter_secure_storage ^9.2.2` (declarado;
    aún no implementado).
  - **Modelos/serialización:** `freezed_annotation ^2.4.4` +
    `json_annotation ^4.9.0`, con `build_runner`, `freezed` y
    `json_serializable` como dev dependencies (declarados; aún no usados).
  - **Utilidades:** `intl ^0.19.0`, `cupertino_icons ^1.0.8`.
  - **Lint:** `flutter_lints ^4.0.0`, vía `analysis_options.yaml`, sin reglas
    adicionales (política explícita: no agregar reglas sin autorización).
  - **Android toolchain:** Gradle 8.12, AGP 8.9.1, Kotlin 2.1.0.

---

## Sprints completados

### Sprint 0 — Verificación inicial (auditoría, sin cambios)

**Objetivo:** auditar el proyecto Flutter recién creado antes de tocar
código, sin modificar ningún archivo.

**Qué se hizo:** revisión de `pubspec.yaml`, `analysis_options.yaml`,
estructura de `lib/`, `android/`, `ios/` y configuración general.

**Hallazgos principales:**
- El proyecto era un `flutter create` estándar con toolchain moderno y
  coherente (Gradle/AGP/Kotlin actuales), `pubspec.lock` ya resuelto sin
  conflictos.
- La estructura de carpetas por *feature* en `lib/` ya existía (con
  archivos `.gitkeep`), anticipando el diseño arquitectónico.
- **No existía repositorio Git** (`.git/` ausente) pese a que ya había un
  `.gitignore` configurado.
- `test/widget_test.dart` era el test de plantilla del contador de
  `flutter create`, y referenciaba una clase `MyApp` inexistente
  (`lib/main.dart` define `ZungofeeApp`) — test roto desde el origen.
- Application ID / Bundle ID seguían siendo el placeholder
  `com.example.zungofee_mobile` (Android) / `com.example.zungofeeMobile`
  (iOS). **Sigue pendiente**, ver "Pendientes".
- Firma de release de Android usando `signingConfigs.debug` (marcado con
  `TODO` en `build.gradle.kts`). **Sigue pendiente.**
- No se encontró en el repositorio (ni en directorios cercanos) la
  documentación de arquitectura referenciada en comentarios de
  `pubspec.yaml` ("doc 02", "doc 03", ADR-004, ADR-005).

**Archivos creados/modificados:** ninguno (tarea de solo lectura).

**Decisiones de arquitectura:** ninguna tomada en esta etapa; solo
diagnóstico.

---

### Sprint 0.5 — Preparación de infraestructura

**Objetivo:** dejar el proyecto listo para el desarrollo oficial, corrigiendo
los bloqueantes detectados en Sprint 0.

**Qué se implementó:**
1. Se inicializó Git (`git init`) — el repositorio no existía previamente.
2. Se configuró el remoto `origin` apuntando a
   `https://github.com/JosueJafet/ZUNGOFFEE-MOVIL-APP.git`.
3. Se corrigió `test/widget_test.dart`: se reemplazó el smoke test de
   plantilla (dependiente de `MyApp` y un contador inexistente) por un test
   mínimo que renderiza `ZungofeeApp` dentro de un `ProviderScope` y verifica
   que se construya sin errores.
4. Primer commit de la estructura base del proyecto (ya con el test
   corregido, para no versionar un test roto).

**Archivos creados:** ninguno nuevo (fuera del propio repositorio Git).

**Archivos modificados:** `test/widget_test.dart`.

**Decisiones de arquitectura:**
- El primer commit se hizo con la estructura ya "sana" (test corregido)
  en vez de versionar primero el estado roto y arreglarlo después, para que
  el historial no arranque con una regresión conocida.
- No se resolvieron en esta etapa los placeholders de Application ID/Bundle
  ID ni la firma de release: quedaron explícitamente fuera de alcance de
  Sprint 0.5 y siguen pendientes.

---

### Sprint 1 — Task 1: Theme System

**Objetivo:** construir el sistema de theming de la app en
`lib/core/theme/`, basado estrictamente en la Guía de Marca oficial de
Zungoffee (PDF `Zungoffee-Guia-de-Marca`, compartida por el usuario), sin
inventar colores, tipografía, espaciados ni radios.

**Qué se implementó:** tokens de diseño en capas (color, tipografía,
espaciado, radios), una `ThemeExtension` para tokens sin slot equivalente en
`ColorScheme`, y un `AppTheme` que compone todo en `ThemeData.light` /
`ThemeData.dark`, incluyendo estilos de botones, inputs, cards y chips, para
que los widgets estándar de Material hereden el estilo de marca vía
`Theme.of(context)`.

**Archivos creados** (`lib/core/theme/`):
- `app_colors.dart` — `AppColors` (paleta fija: cereza, oliva, pergamino,
  tueste, oro tostado, ink), `AppLightColors` / `AppDarkColors` (roles
  semánticos background/card/foreground/primary/secondary/
  mutedForeground/destructive), `AppCoffeeStageColors` (5 etapas de
  `estados_cafe`: uva, húmedo, pergamino, tueste, molido).
- `app_typography.dart` — `AppFontFamily` (Poppins/Inter/JetBrains Mono) y
  `AppTypography` (display, heading, subheading, body, caption,
  tabularData).
- `app_spacing.dart` — `AppSpacing` (`space2`=8, `space4`=16, `space6`=24;
  únicamente los tokens documentados en la guía).
- `app_radius.dart` — `AppRadius` (`sm`=6, `md`=8, `lg`=10, `xl`=14) +
  getters `BorderRadius` de conveniencia.
- `theme_extensions.dart` — `AppColorsExtension` (accent, mutedForeground,
  colores de etapa) + extensión `context.appColors`.
- `app_theme.dart` — `AppTheme.light` / `AppTheme.dark`.

**Decisiones de arquitectura:**
- Contenedores de tokens implementados como `abstract final class` (Dart 3):
  no instanciables, solo namespaces estáticos.
- No se registraron los archivos de fuente (`Poppins`/`Inter`/`JetBrains
  Mono`) en `pubspec.yaml` (`flutter.fonts`): implicaría agregar assets, algo
  fuera de alcance de la tarea ("no agregar dependencias nuevas"). Los
  nombres de familia están declarados y listos para cuando se agreguen los
  `.ttf`.
- `JetBrains Mono` no tenía tamaño/peso explícito en la guía (a diferencia
  de los otros 5 estilos); se usó 16px/400 (la unidad base `1rem` del propio
  sistema de la guía) en vez de inventar un valor, dejándolo documentado en
  el código como supuesto explícito.
- Tokens `on*` (texto sobre color) no definidos por la guía: `onPrimary` /
  `onError` = blanco (estándar de contraste sobre tonos saturados, visible
  en el mock "Registrar mi bodega" de la guía); `onSecondary` / `onSurface`
  = `foreground` del tema correspondiente.
- Mapeo de los 6 estilos de marca a slots de `TextTheme` de Material
  (`headlineMedium→display`, `titleLarge→heading`, `titleMedium→subheading`,
  `bodyLarge→body`, `bodyMedium→caption`, `labelLarge→tabularData`): decisión
  de diseño, ya que la guía no nombra slots de Material.
- El botón "soft destructivo" ("Eliminar lote" en el mock) no se themó a
  nivel `ThemeData` por no corresponder a ningún tipo de botón estándar de
  Material; queda para la futura tarea de widgets reutilizables
  (`shared/widgets/buttons`).
- **No se modificó `main.dart`**: el alcance de la tarea era únicamente
  `lib/core/theme/`. Conectar `MaterialApp` con `AppTheme.light`/`dark`
  queda pendiente (ver "Pendientes").
- La Guía de Marca en sí (PDF) **no está guardada en el repositorio**; fue
  compartida directamente en la conversación. Ver "Pendientes".

**Validación:** `flutter analyze` sin issues; `flutter test` con todos los
tests pasando.

---

### Sprint 1 — Task 2: Router Infrastructure

**Objetivo:** construir la infraestructura de navegación en
`lib/core/router/` usando GoRouter como único sistema de rutas, centralizada
y escalable, sin implementar pantallas de negocio reales.

**Qué se implementó:** nombres y paths de ruta centralizados en constantes
propias, una tabla única de rutas (`AppRoutes.routes`) y un punto único de
acceso al `GoRouter` (`AppRouter.router`). Dos pantallas placeholder
mínimas (`SplashPlaceholderScreen`, `HomePlaceholderScreen`) para validar
que la navegación funciona, más un test que verifica la transición entre
ambas.

**Archivos creados:**
- `lib/core/router/route_names.dart` — `RouteNames`.
- `lib/core/router/route_paths.dart` — `RoutePaths`.
- `lib/core/router/app_routes.dart` — `AppRoutes.routes`.
- `lib/core/router/app_router.dart` — `AppRouter.router`.
- `lib/core/router/screens/splash_placeholder_screen.dart` —
  `SplashPlaceholderScreen`.
- `lib/core/router/screens/home_placeholder_screen.dart` —
  `HomePlaceholderScreen`.
- `test/core/router/app_router_test.dart` — test de navegación
  splash → home.

**Archivos eliminados:** `lib/core/router/.gitkeep` (la carpeta dejó de
estar vacía).

**Decisiones de arquitectura:**
- Nombres (`RouteNames`) y paths (`RoutePaths`) en archivos separados:
  separa "cómo se navega por nombre" de "cómo se navega por URL"; el resto
  del código no debería usar strings de ruta directamente.
- Escalabilidad vía lista (`AppRoutes.routes`), no vía edición de
  `GoRouter`: agregar un módulo futuro solo requiere una constante nueva en
  `RouteNames`/`RoutePaths` y una entrada en la lista; `app_router.dart` no
  cambia.
- Pantallas placeholder ubicadas dentro de `core/router/screens/` (no en
  `features/`): son código de infraestructura desechable para probar el
  router, marcadas explícitamente en el código para reemplazo futuro.
- Sin Riverpod provider para el router (fuera de alcance de la tarea):
  `AppRouter.router` es un getter estático, mismo patrón que `AppTheme`.
- **No se modificó `main.dart`**: mismo criterio que en Task 1: alcance
  limitado a `lib/core/router/`. Conectar
  `MaterialApp.router(routerConfig: AppRouter.router)` queda pendiente.

**Validación:** `flutter analyze` sin issues; `flutter test` con todos los
tests pasando (incluye el nuevo test de navegación).

---

## Estado del repositorio

- **Rama principal:** `main` (renombrada desde `master` al cerrar el
  Sprint 1; ya publicada en `origin/main`).
- **Ramas existentes:**
  - `main` — integra todo el trabajo aprobado hasta la fecha (Sprint 0.5 +
    Sprint 1 Task 1 + Task 2). Sincronizada con `origin/main`.
  - `feature/theme-system` — rama de trabajo de Sprint 1 Task 1, ya
    integrada (fast-forward) en `main`. No eliminada.
  - `feature/router-infrastructure` — rama de trabajo de Sprint 1 Task 2,
    ya integrada (fast-forward) en `main`. No eliminada.
- **Remoto:** `origin` → `https://github.com/JosueJafet/ZUNGOFFEE-MOVIL-APP.git`.
  Se hizo el primer push de `main` (`git push -u origin main`); las ramas
  `feature/*` permanecen solo locales.
- **Commits importantes (historial de `main`, en orden):**
  1. `chore: initial Flutter project structure` — primer commit del
     proyecto (Sprint 0.5).
  2. `feat(theme): add brand color tokens`
  3. `feat(theme): add typography tokens`
  4. `feat(theme): add spacing and radius tokens`
  5. `feat(theme): add theme extension for brand-specific tokens`
  6. `feat(theme): implement application theme system`
  7. `feat(router): add centralized route name and path constants`
  8. `feat(router): add minimal placeholder screens for navigation testing`
  9. `feat(router): configure application router`
  10. `test(router): verify navigation between placeholder screens`
  11. `chore(router): remove now-unneeded .gitkeep`

---

## Estructura actual del proyecto

```
lib/
  core/                     Infraestructura transversal (sin lógica de negocio)
    api/                    (vacío — pendiente: cliente Dio)
    config/                 (vacío)
    constants/              (vacío)
    errors/                 (vacío)
    router/                 Navegación (GoRouter) — implementado
      screens/              Pantallas placeholder de validación
    services/               (vacío)
    theme/                  Sistema de theming — implementado
    utils/                  (vacío)
  features/                 Un directorio por módulo de negocio, mismo
                             patrón en los 9 módulos: auth, clientes,
                             compras, dashboard, inventario, notificaciones,
                             perfil, procesamiento, proveedores, reportes,
                             ventas. Todos vacíos (solo `.gitkeep`).
    <feature>/
      data/
        datasources/
        dtos/
        models/
        repositories/
      presentation/
        providers/
        screens/
        widgets/
  shared/                   Elementos reutilizables entre features (vacío)
    extensions/
    mixins/
    widgets/
      buttons/ cards/ dialogs/ empty_states/ inputs/ loaders/ snackbars/
  main.dart                 Entry point mínimo (ProviderScope + MaterialApp
                             con un Scaffold estático). Aún no conecta
                             AppTheme ni AppRouter.
test/
  core/router/app_router_test.dart   Test de navegación
  widget_test.dart                   Smoke test de ZungofeeApp
docs/
  PROJECT_STATUS.md         Este documento
android/, ios/              Scaffolding estándar de `flutter create`
```

---

## Decisiones arquitectónicas

1. **Clean Architecture por feature**, con capas `data/` y `presentation/`
   dentro de cada módulo — definido antes de Sprint 0 (ya existía en el
   scaffold inicial), mantenido sin cambios en todos los sprints.
2. **Riverpod** (`flutter_riverpod`) como gestor de estado oficial —
   declarado en `pubspec.yaml`, usado por ahora solo para envolver la app
   (`ProviderScope`) en `main.dart`.
3. **GoRouter** como único sistema de navegación — implementado en
   Sprint 1 Task 2, sin guards/middleware/deep links (explícitamente fuera
   de alcance por ahora).
4. **Sistema de theming basado 100% en la Guía de Marca oficial**, sin
   valores inventados; separación en capas (colores / tipografía /
   espaciado / radios / extensión de tema / composición final en
   `AppTheme`).
5. **Tokens de diseño como `abstract final class` con miembros estáticos**
   (patrón Dart 3): evita instanciación, funciona como namespace puro.
6. **Nombres y paths de ruta centralizados** en constantes propias
   (`RouteNames`, `RoutePaths`) para evitar strings repetidos.
7. **Cada tarea de infraestructura se limita estrictamente a su alcance
   declarado** (p. ej. Theme System no toca `main.dart`; Router
   Infrastructure no toca `features/`): decisión de proceso repetida en
   ambas tareas de Sprint 1, para mantener cada Pull Request pequeño y
   revisable de forma aislada.
8. **`analysis_options.yaml` usa únicamente `flutter_lints` base**, sin
   reglas adicionales, por política explícita del equipo (comentario en el
   propio archivo).
9. **Rama principal `main`** (no `master`), con flujo de ramas
   `feature/*` → merge (fast-forward) → `main`.

---

## Pendientes

Lo que falta por implementar, en el orden en que fue quedando pendiente:

- **Conectar `AppTheme` y `AppRouter` en `main.dart`**: hoy `main.dart`
  sigue siendo el `MaterialApp` estático generado en Sprint 0; no usa
  `ThemeData` de `AppTheme` ni `MaterialApp.router` con `AppRouter.router`.
- **Application ID / Bundle ID siguen siendo placeholders**:
  `com.example.zungofee_mobile` (Android) y `com.example.zungofeeMobile`
  (iOS). Detectado en Sprint 0, no resuelto en ningún sprint posterior.
- **Firma de release de Android** sigue usando `signingConfigs.debug`
  (marcado con `TODO` en `android/app/build.gradle.kts`). No resuelto.
- **La Guía de Marca (PDF) no está versionada en el repositorio.** Fue
  compartida directamente en la conversación durante Sprint 1 Task 1;
  se recomienda guardarla en `docs/` (p. ej. `docs/brand/`) para que
  quede disponible sin depender del historial de chat.
- **Registro de fuentes de marca** (`Poppins`, `Inter`, `JetBrains Mono`)
  en `pubspec.yaml` (`flutter.fonts`) y sus archivos `.ttf`: los nombres de
  familia ya están declarados en `AppTypography`, pero los assets no se han
  agregado.
- **Botón "soft destructivo"** (variante vista en el mock "Eliminar lote"
  de la Guía de Marca) no tiene equivalente en los temas de botón estándar
  de Material; pendiente para cuando se implementen los widgets
  reutilizables de `shared/widgets/buttons`.
- **Ningún módulo de `features/` tiene código** — todas las carpetas
  siguen vacías (`.gitkeep`), incluyendo `auth`, que normalmente sería el
  primer módulo a implementar.
- **`core/api`, `core/config`, `core/constants`, `core/errors`,
  `core/services`, `core/utils`** siguen vacíos — ningún cliente Dio,
  manejo de errores, servicios (p. ej. `flutter_secure_storage`) ni
  utilidades implementados todavía.
- **`shared/` completo** (extensions, mixins, widgets) sigue vacío.
- **Sin integración con backend real**: no hay definido aún un cliente Dio,
  DTOs, modelos ni repositorios — bloqueado a propósito (ver "Información
  importante").

---

## Próximo Sprint recomendado

**Sprint 1 — Task 3 (o Sprint 2, según se decida numerar): completar la
base de `core/` y ensamblar `main.dart`.**

Concretamente, cuando se retome el desarrollo:
1. Conectar `AppTheme` (claro/oscuro) y `AppRouter` en `main.dart`,
   reemplazando el `MaterialApp` estático actual por
   `MaterialApp.router` con `theme`/`darkTheme` y `routerConfig`.
2. Resolver los pendientes de configuración nativa (Application ID real,
   firma de release) antes de que bloqueen un primer build de
   distribución.
3. Recién después de eso, y **solo cuando el backend oficial esté
   desplegado y su contrato de API confirmado**, iniciar el primer módulo
   de negocio real (candidato natural: `features/auth`, ya que el resto de
   módulos probablemente dependan de sesión/autenticación).

No se recomienda iniciar ningún módulo de `features/` antes de tener
confirmado el contrato del backend, para evitar tener que rehacer DTOs,
modelos o repositorios.

---

## Información importante

**El desarrollo queda pausado a la espera del despliegue oficial del
backend.** La aplicación móvil debe adaptarse al backend existente (no al
revés): estructuras de datos, endpoints, autenticación, estados de negocio
(como `estados_cafe`) y cualquier contrato de API deberán tomarse
directamente de lo que el backend ya define, sin anticipar ni inventar
modelos, DTOs o repositorios mientras ese backend no esté confirmado y
accesible. Cuando se retome el proyecto, el primer paso antes de tocar
`features/` debe ser validar contra el backend real qué datos y contratos
existen.
