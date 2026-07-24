# Zungoffee Mobile — Estado del Proyecto

> Documento vivo. Objetivo: que cualquier desarrollador (o una futura sesión
> de IA) pueda retomar el proyecto exactamente desde este punto sin perder
> contexto. Actualizar este archivo al cerrar cada Sprint.

Última actualización: cierre de Sprint 5 (Tasks 1–6), con `main` ya
integrando todo lo aprobado y sincronizado con `origin/main`.

---

## Project Snapshot

| Campo | Estado |
|---|---|
| Sprint actual | Sprint 5 completado (Tasks 1–6) |
| Arquitectura | Clean Architecture por feature + capa `core/` transversal |
| Backend | NestJS + Prisma + Supabase (Postgres), staging en Render — integrado |
| Autenticación | Login real (`features/auth`) contra Supabase Auth, con guards de sesión en GoRouter y perfil (`GET /perfil`) vía Riverpod |
| Dashboard | Home real (`features/dashboard`) con bienvenida desde `Perfil`, logout funcional y entrada de navegación a Proveedores |
| Proveedores | Primer módulo de negocio real (`features/proveedores`): listar, crear y editar proveedores, integrado al Router |
| Tests | 88/88 pasando (`flutter test`) |
| flutter analyze | Sin issues |
| Entorno | Flutter `>=3.35.6` / Dart `>=3.9.0`; solo staging (sin producción separada) |
| Plataforma objetivo | Android |
| Rama principal | `main` (fast-forward de las 23 ramas de Sprint 1+2+3+4+5; sincronizada con `origin/main`) |
| Próximo Sprint | Por definir — candidatos: guards por rol en el router, o el siguiente módulo de negocio (`compras`, `clientes`, `inventario`) |

---

## Información general

- **Nombre del proyecto:** Zungofee Mobile (paquete Dart: `zungofee_mobile`).
- **Objetivo:** aplicación móvil (Zungo Coffee) para la operación diaria en
  campo de una bodega de café — registrar compras a productores, ver
  existencias, procesar (tostar/moler) y registrar ventas. Es uno de los dos
  clientes de la misma API REST (el otro es el panel web en Next.js, para
  `admin_bodega`/`super_admin`); la app móvil es principalmente para
  `empleado` y `admin_bodega` en campo. Debe verse y comportarse como la
  misma identidad de producto que el panel web (misma paleta, tipografía y
  jerarquía de componentes).
- **Estado actual:** infraestructura base completa — Sprint 0, 0.5, Sprint 1
  (Theme + Router), Sprint 2 (Network, Session, Constants/Utils, Router
  Guards, App Bootstrap), Sprint 3 (feature `auth`: login real, perfil,
  providers de Riverpod), Sprint 4 (feature `dashboard`: Home real con
  bienvenida y logout) y Sprint 5 (feature `proveedores`: primer módulo de
  negocio real — listar, crear y editar proveedores, integrado al Router)
  implementados y aprobados. El backend oficial (staging) ya está
  desplegado e integrado. `features/auth`, `features/dashboard` y
  `features/proveedores` son los únicos módulos de negocio con código
  real; el resto de `features/*` sigue vacío. Ver "Próximo Sprint
  recomendado".
- **Plataforma objetivo:** Android. El proyecto también contiene el
  scaffolding de `ios/` generado por `flutter create`, pero el foco de
  desarrollo declarado es Android.
- **Arquitectura utilizada:** Clean Architecture por *feature*, con
  separación `data/` (`datasources`, `dtos`, `models`, `repositories`) y
  `presentation/` (`providers`, `screens`, `widgets`) dentro de cada módulo
  de negocio, más una capa `core/` (infraestructura transversal, ya
  sustancialmente construida en Sprint 2) y `shared/` (elementos reutilizables
  entre features, aún vacío). Ver detalle en "Estructura actual del
  proyecto".
- **Backend:** NestJS + Prisma sobre PostgreSQL (Supabase), multi-tenant.
  Staging desplegado en Render (`https://zungo-coffee-api.onrender.com`,
  plan free — cold start de ~30-50s tras inactividad). Aún no existe un
  ambiente de producción separado. Autenticación 100% vía Supabase Auth
  (JWT), no vía la API de NestJS. Documentación completa del contrato de API
  en `CONTEXTO-MOVIL-FLUTTER.md` (compartido en conversación; ver
  "Pendientes" sobre versionarlo).
- **Tecnologías aprobadas** (declaradas en `pubspec.yaml`):
  - **Flutter / Dart:** SDK Dart `>=3.3.0 <4.0.0`; toolchain resuelto con
    Flutter `>=3.35.6` / Dart `>=3.9.0` (`pubspec.lock`).
  - **Gestión de estado:** `flutter_riverpod ^2.5.1` — providers reales
    desde Sprint 3 (`authSessionServiceProvider`/`apiClientProvider` en
    `core/`, y `authRepositoryProvider`/`perfilProvider`/
    `loginControllerProvider`/`logoutControllerProvider` en
    `features/auth`, este último agregado en Sprint 4), API clásica sin
    `riverpod_generator`.
  - **Cliente HTTP:** `dio ^5.4.3` — **implementado** en Sprint 2
    (`ApiClient`, `core/api/`).
  - **Navegación:** `go_router ^14.2.0` — implementado en Sprint 1,
    extendido con guards de sesión en Sprint 2.
  - **Autenticación:** `supabase_flutter ^2.16.0` — **nueva dependencia de
    Sprint 2** (Task 2), envuelta por `AuthSessionService`.
  - **Almacenamiento seguro:** `flutter_secure_storage ^9.2.2` (declarado;
    **deliberadamente sin usar** — Supabase persiste su propia sesión;
    reservado para otros secretos si hicieran falta a futuro).
  - **Modelos/serialización:** `freezed_annotation ^2.4.4` +
    `json_annotation ^4.9.0`, con `build_runner`, `freezed` y
    `json_serializable` como dev dependencies — **primer uso real en Sprint
    3** (`PerfilDto`/`Perfil`, `features/auth`). `analysis_options.yaml`
    ignora `invalid_annotation_target` (falso positivo documentado de
    `freezed` + `json_serializable` con `@JsonKey` en parámetros de
    constructor).
  - **Utilidades:** `intl ^0.19.0` (usado por `ApiDate` desde Sprint 2),
    `cupertino_icons ^1.0.8`.
  - **Lint:** `flutter_lints ^4.0.0`, vía `analysis_options.yaml`, sin reglas
    adicionales (política explícita: no agregar reglas sin autorización).
  - **Android toolchain:** Gradle 8.12, AGP 8.9.1, Kotlin 2.1.0.

---

## Sprints completados

### Sprint 0 — Verificación inicial (auditoría, sin cambios)

**Objetivo:** auditar el proyecto Flutter recién creado antes de tocar
código, sin modificar ningún archivo.

**Hallazgos principales:** no existía repositorio Git; `test/widget_test.dart`
era el test de plantilla del contador (roto, referenciaba `MyApp`); Application
ID/Bundle ID seguían siendo el placeholder `com.example.*`; firma de release
de Android usando `signingConfigs.debug`; no se encontró en el repositorio la
documentación de arquitectura referenciada en comentarios de `pubspec.yaml`
("doc 02", "doc 03", ADR-004, ADR-005). Todo esto **sigue pendiente** salvo
lo corregido en Sprint 0.5 (ver "Pendientes").

**Archivos creados/modificados:** ninguno. **Decisiones:** ninguna, solo
diagnóstico.

---

### Sprint 0.5 — Preparación de infraestructura

**Objetivo:** dejar el proyecto listo para el desarrollo oficial.

**Qué se implementó:** `git init`; remoto `origin` configurado
(`https://github.com/JosueJafet/ZUNGOFFEE-MOVIL-APP.git`); se corrigió
`test/widget_test.dart` (smoke test de plantilla → smoke test real de
`ZungofeeApp`); primer commit de la estructura base (ya con el test
corregido).

**Decisiones:** el primer commit se hizo con la estructura ya "sana", no con
el estado roto. Los placeholders de Application ID/Bundle ID y la firma de
release quedaron explícitamente fuera de alcance y siguen pendientes.

---

### Sprint 1 — Task 1: Theme System

**Objetivo:** construir el sistema de theming en `lib/core/theme/`, basado
estrictamente en la Guía de Marca oficial de Zungoffee (PDF, compartido por
el usuario), sin inventar colores, tipografía, espaciados ni radios.

**Qué se implementó:** `app_colors.dart` (paleta fija + roles semánticos
claro/oscuro + colores de las 5 etapas de café), `app_typography.dart`
(Poppins/Inter/JetBrains Mono), `app_spacing.dart`, `app_radius.dart`,
`theme_extensions.dart` (`AppColorsExtension` + `context.appColors`), y
`app_theme.dart` (`AppTheme.light`/`dark`, incluyendo botones/inputs/
cards/chips).

**Decisiones clave:** tokens como `abstract final class` (namespaces
estáticos); fuentes declaradas por nombre pero **sin registrar** en
`pubspec.yaml` (implicaría assets, fuera de alcance); `JetBrains Mono` sin
tamaño explícito en la guía → se usó 16px/400 (la unidad base `1rem` del
propio sistema de la guía) como supuesto documentado; tokens `on*` no
definidos por la guía → blanco sobre tonos saturados, `foreground` del tema
sobre `secondary`; mapeo de los 6 estilos de marca a slots de `TextTheme` de
Material fue decisión de diseño propia. No se tocó `main.dart` (fuera de
alcance).

---

### Sprint 1 — Task 2: Router Infrastructure

**Objetivo:** infraestructura de navegación en `lib/core/router/` con
GoRouter, centralizada y escalable, sin pantallas de negocio reales.

**Qué se implementó:** `route_names.dart`/`route_paths.dart` (constantes
centralizadas), `app_routes.dart` (`AppRoutes.routes`), `app_router.dart`
(en ese momento, `AppRouter.router` como `static final` sin dependencias),
pantallas placeholder `SplashPlaceholderScreen`/`HomePlaceholderScreen`, y un
test de navegación splash → home.

**Decisiones clave:** nombres y paths en archivos separados; escalar rutas
vía lista (`AppRoutes.routes`) sin tocar `app_router.dart`; placeholders
dentro de `core/router/screens/` (no en `features/`), marcados para
reemplazo futuro; sin Riverpod provider para el router (fuera de alcance).
No se tocó `main.dart`.

---

### Sprint 2 — Network & Session Infrastructure

Con el backend oficial ya desplegado (staging, Render) y su contrato de API
documentado (`CONTEXTO-MOVIL-FLUTTER.md`), este Sprint completó el resto de
`core/` y conectó por primera vez la app con Supabase/la API real — sin
implementar ninguna pantalla o lógica de negocio de una feature.

#### Task 1 — Environment Configuration (`lib/core/config/`)

**Qué se implementó:** `app_environment.dart` (`AppEnvironment`) con URL/anon
key de Supabase y URL base de la API (staging por defecto,
`--dart-define=API_BASE_URL=...` para local), y timeouts de red de 60s
pensados para el cold start documentado de Render.

**Decisiones:** el anon key se embebe como default en código — el propio
contexto técnico aclara que es un valor público seguro por diseño de
Supabase (protegido por RLS), a diferencia de la `service_role key` (nunca
debe estar en la app). Sin sistema de flavors dev/staging/prod: el backend
documenta que aún no existe un ambiente de producción separado.

#### Task 2 — Session Service Foundation (`lib/core/services/`)

**Qué se implementó:** `supabase_bootstrap.dart` (`SupabaseBootstrap.
initialize()`) y `auth_session_service.dart` (`AuthSessionService`: sesión
actual, JWT, `isAuthenticated`, `onAuthStateChange`, `signInWithPassword`,
`signOut`).

**Decisiones:** nueva dependencia `supabase_flutter ^2.16.0`. Se usó
`publishableKey` (no `anonKey`, deprecado en esta versión del SDK) al
inicializar Supabase. **No** se usa `flutter_secure_storage` para el JWT:
Supabase ya persiste y refresca su propia sesión — reinventarlo sería
duplicar trabajo. `AuthSessionService` recibe el `SupabaseClient` por
constructor (no lee el singleton `Supabase.instance` directamente) para
poder sustituirlo en tests.

#### Task 3 — Network Client & Error Handling (`lib/core/api/` + `lib/core/errors/`)

**Qué se implementó:** `api_exception.dart` (`ApiException`, con
`isForbidden`/`isUnauthorized`/`isBadRequest`), `network_exception.dart`
(`NetworkException`, para fallas de conectividad sin respuesta), y
`api_client.dart` (`ApiClient`: cliente Dio centralizado con interceptor de
`Authorization: Bearer` y traducción de cualquier `DioException` a una de
las dos excepciones tipadas).

**Decisiones:** manejo de errores con **excepciones tipadas** (no
Result/Either) — decisión validada explícitamente con el usuario, por
integrar sin boilerplate con `AsyncValue.guard` de Riverpod. Se introdujo
`SessionTokenProvider` (interfaz en `core/api`, implementada por
`AuthSessionService`) para invertir la dependencia y poder testear
`ApiClient` sin Supabase. La traducción de errores se hace en un método
interno (`_guard`/`_translate`), no en un `Interceptor.onError`, porque la
API de Dio solo permite relanzar como `DioException` — así los repositories
reciben la excepción tipada directamente. `message` se parsea también como
posible `List<String>` (formato de validación de NestJS), sin inventar
datos nuevos. Sin cola de reintentos/offline (mencionado en el contexto
técnico como decisión futura, no de este sprint).

#### Task 4 — Domain Constants & Parsing Utilities (`lib/core/constants/` + `lib/core/utils/`)

**Qué se implementó:** `estado_cafe.dart` (`EstadoCafeId`: catálogo de 7
IDs; `EstadoCafeTransiciones.esValida`: reglas de transición documentadas —
pergamino→tostado, tostado→molido), `app_role.dart` (`AppRole`),
`pagination_limits.dart` (`PaginationLimits`), `bigint_id.dart` (`BigIntId`:
IDs BigInt que llegan como `String`), `api_decimal.dart` (`ApiDecimal`:
decimales que llegan como `String`), `api_date.dart` (`ApiDate`: formato
`YYYY-MM-DD` / ISO completo).

**Decisiones:** todos los valores tomados literalmente del contexto técnico,
sin inventar ninguno. Los parsers aceptan defensivamente `num` además de
`String` (tolerancia a un cambio futuro del backend, no una suposición sobre
el contrato actual). `EstadoCafeTransiciones.esValida` es solo una
validación temprana de UX — la API sigue siendo la fuente de verdad final.

#### Task 5 — Router Session-Aware Guards (extiende `lib/core/router/`)

**Qué se implementó:** ruta `login` (`LoginPlaceholderScreen`),
`auth_redirect.dart` (`AuthRedirect.resolve`: lógica pura de redirect según
sesión) y `go_router_refresh_stream.dart` (`GoRouterRefreshStream`: conecta
`onAuthStateChange` con `GoRouter.refreshListenable`). `AppRouter` pasó de
`static final GoRouter router` a `static GoRouter build(AuthSessionService)`.

**Decisiones:** toda ruta que no sea `login` se trata como protegida (no hay
lista explícita de "rutas públicas" porque no existe otra hoy). La decisión
de redirect se aisló en una función pura (`AuthRedirect.resolve`) para poder
testear las 4 combinaciones sin Supabase — ahí es literalmente donde se
simula la "sesión activa" en los tests, no autenticando de verdad. El test
de integración del router solo cubre el caso "sin sesión" (con un
`SupabaseClient` real sin sesión persistida); simular un login real habría
requerido falsificar las respuestas HTTP de GoTrue.

#### Task 6 — Application Bootstrap (`lib/main.dart`)

**Qué se implementó:** `main()` ahora `async`: inicializa Supabase antes de
`runApp`, construye `AuthSessionService` y el `GoRouter`
(`AppRouter.build(...)`) **una única vez**, y los pasa por constructor a
`ZungofeeApp`, que ahora usa `MaterialApp.router` con `theme`/`darkTheme` de
`AppTheme`.

**Decisiones:** el router se construye una sola vez en `main()`, nunca
dentro de `build()` (perdería historial de navegación y se re-suscribiría al
stream de auth en cada rebuild) — por eso `ZungofeeApp` pasó a recibir
`router` por constructor. Bug encontrado y corregido durante la validación:
todo `SupabaseClient` arranca un `Timer.periodic` de auto-refresh al
construirse; los tests que crean uno deben cerrarlo con `.dispose()` en
`tearDown` o `flutter test` falla por "timer pendiente" (corregido en
`widget_test.dart` y `app_router_test.dart`).

**Validación de las 6 tasks:** `flutter analyze` sin issues y `flutter test`
en verde (25/25) al cierre de cada una.

---

### Sprint 3 — Feature: Auth

Primer módulo de negocio real del proyecto: login funcional, perfil del
usuario autenticado (`GET /perfil`) y el estado de sesión/perfil expuesto
vía Riverpod para el resto de la app. Nota de arquitectura seguida en las 6
tasks: la feature `auth` nunca depende del Router ni navega directamente —
el único mecanismo que activa los redirects de `AppRouter` sigue siendo el
cambio de estado de sesión (`AuthSessionService.onAuthStateChange` →
`GoRouterRefreshStream`), tal como se estableció desde Sprint 2.

#### Task 1 — Core Riverpod Providers (`lib/core/services/auth_providers.dart`, `lib/core/api/api_providers.dart`)

**Qué se implementó:** `authSessionServiceProvider` y `apiClientProvider`,
primeros providers reales del proyecto. `main.dart` pasó a construir un
`ProviderContainer` explícito antes de `runApp`, leer
`authSessionServiceProvider` de ahí para `AppRouter.build(...)`, y montar
la app con `UncontrolledProviderScope` — una única instancia de
`AuthSessionService`/`ApiClient` en toda la app, no una "de main.dart" y
otra "de Riverpod" corriendo por separado.

#### Task 2 — Perfil: DTO y modelo de dominio (`lib/features/auth/data/dtos/perfil_dto.dart`, `lib/features/auth/data/models/perfil.dart`)

**Qué se implementó:** `PerfilDto` (+ `PerfilRolDto`/`PerfilTenantDto`
anidados, fieles al JSON snake_case de `GET /perfil`) y el modelo de
dominio `Perfil` (freezed, camelCase), con `PerfilDto.toDomain()` como
mapeo. Primer uso real de `freezed`/`json_serializable`/`build_runner` en
el proyecto.

**Decisiones:** se agregó `analyzer.errors.invalid_annotation_target:
ignore` a `analysis_options.yaml` — falso positivo conocido y documentado
por `freezed` cuando se usa `@JsonKey` en un parámetro de constructor.

#### Task 3 — Auth y Perfil: Repositories (`lib/features/auth/data/repositories/`, `lib/features/auth/data/datasources/`)

**Qué se implementó:** `AuthRepository` (delega `signIn`/`signOut`/
`isAuthenticated`/`onAuthStateChange` en `AuthSessionService`, sin
reimplementar nada), `PerfilRemoteDataSource` (`GET /perfil` →
`PerfilDto`) y `PerfilRepository` (mapea a `Perfil`, deja pasar
`ApiException`/`NetworkException` tal cual).

**Decisiones:** los tests de estas clases se hicieron subclasificando
directamente `AuthRepository`/`PerfilRepository` (no son interfaces) para
crear fakes por herencia, sin sumar un mocking framework nuevo.

#### Task 4 — Providers de Riverpod de la feature (`lib/features/auth/presentation/providers/`)

**Qué se implementó:** `authRepositoryProvider`/`perfilRepositoryProvider`
(sobre los providers de Task 1), `authStateProvider`/
`isAuthenticatedProvider` (estado de sesión reactivo), `perfilProvider`
(`FutureProvider` que se reevalúa en cada cambio de sesión, para no dejar
en caché el perfil de un usuario anterior tras un logout), y
`loginControllerProvider` (`AsyncNotifier<void>` que expone loading/error/
success del login).

**Decisiones:** al asignar `state = AsyncLoading()` en un `AsyncNotifier`,
Riverpod adjunta automáticamente el valor previo (`copyWithPrevious`) —
comportamiento documentado del framework, no un bug; los tests verifican
`isLoading`/`hasError` en vez de igualdad estricta de instancia.

#### Task 5 — Pantalla de Login real (`lib/features/auth/presentation/screens/login_screen.dart`)

**Qué se implementó:** `LoginScreen` (`ConsumerStatefulWidget`) con
`Form`/`TextFormField` estándar (sin widgets nuevos en `shared/`),
estilado 100% vía `ThemeData` (Sprint 1) y `AppSpacing`, validación básica
de correo/contraseña, y mensaje de error desde `ApiException.message`/
`NetworkException.message`.

**Decisiones:** la pantalla nunca navega ni importa `core/router/` — solo
invoca `loginControllerProvider.notifier.signIn(...)` y muestra loading/
error, respetando la nota de arquitectura del sprint.

#### Task 6 — Integración con el Router (`lib/core/router/app_routes.dart`)

**Qué se implementó:** la ruta `login` ahora sirve `LoginScreen` en vez de
`LoginPlaceholderScreen`, que se eliminó por quedar sin uso.
`test/core/router/app_router_test.dart` se envolvió en `ProviderScope`
(requerido porque la ruta ahora renderiza un widget de Riverpod real).

**Validación de las 6 tasks:** `flutter analyze` sin issues y `flutter
test` en verde (40/40) al cierre de cada una y al cierre del Sprint.

---

### Sprint 4 — Feature: Dashboard (Home real)

Primer y único consumidor real de `features/auth`: reemplaza
`HomePlaceholderScreen` por una pantalla que muestra el perfil del
usuario autenticado y permite cerrar sesión. Sin capa de datos nueva —
todo se construye sobre `perfilProvider`/`authRepositoryProvider` ya
existentes de Sprint 3. Misma nota de arquitectura que Sprint 3: la
feature `dashboard` tampoco depende del Router ni navega directamente.

#### Task 1 — Pantalla Home con los 3 estados de `perfilProvider` (`lib/features/dashboard/presentation/screens/home_screen.dart`)

**Qué se implementó:** `HomeScreen` (`ConsumerWidget`) que consume
`perfilProvider` y resuelve `loading`/`error`/`data` con `.when(...)`:
indicador de carga, mensaje de `ApiException`/`NetworkException` + botón
"Reintentar" (`ref.invalidate(perfilProvider)`), y bienvenida con
`perfil.nombre`/`perfil.tenantNombre` en el caso de éxito.

**Decisiones:** contenido mínimo (solo nombre y bodega, sin `rol`/
`fechaCreacion`/`activo`/`tenantId` — decisión explícita del usuario para
esta iteración); el botón "Reintentar" no estaba en el pedido original
pero se agregó por ser barato y coherente con un estado de solo lectura.

#### Task 2 — Acción de logout en la pantalla Home (`lib/features/auth/presentation/providers/logout_controller.dart`)

**Qué se implementó:** `LogoutController` (`AsyncNotifier<void>`,
simétrico a `LoginController`) que ejecuta
`AuthRepository.signOut()`; ícono de logout en el `AppBar` de
`HomeScreen`, con indicador de carga mientras corre y el error mostrado
inline (no en un `SnackBar`, para no depender de un `Timer` real en los
widget tests). Sin diálogo de confirmación (decisión explícita del
usuario).

**Decisiones:** un test adicional (tap doble sin `pump()` entre ambos)
reveló una condición de carrera real — el `state` se actualiza de forma
sincrónica al llamar `signOut()`, pero el rebuild que deshabilita el
botón ocurre recién en el siguiente frame, así que un segundo tap en esa
ventana disparaba un `signOut()` concurrente. Corregido con un guard
(`if (state.isLoading) return;`) al inicio de `LogoutController.signOut()`
— la corrección se hizo en el controller, no en el widget, porque solo
ahí se puede consultar el estado real y actual del notifier (el widget
captura `logoutAsync` en un closure que queda desactualizado hasta el
próximo frame).

#### Task 3 — Integración con el Router (`lib/core/router/app_routes.dart`)

**Qué se implementó:** la ruta `home` ahora sirve `HomeScreen` en vez de
`HomePlaceholderScreen`, que se eliminó por quedar sin uso.
`test/core/router/app_router_test.dart` cambió su aserción de
`find.text('Home placeholder')` a `find.byType(HomeScreen)`.

**Validación de las 3 tasks:** `flutter analyze` sin issues y `flutter
test` en verde (50/50) al cierre de cada una y al cierre del Sprint.

---

### Sprint 5 — Feature: Proveedores (primer módulo de negocio real)

Primer módulo de negocio operativo del proyecto (más allá de `auth` y
`dashboard`), siguiendo el flujo documentado en
`CONTEXTO-MOVIL-FLUTTER.md`: listar, crear y editar proveedores
(`GET`/`POST`/`PATCH /proveedores`). A diferencia de `auth`/`dashboard`,
esta feature **sí navega directamente vía GoRouter** (`context.push`/
`context.pop`) — la regla de "no depender del Router" de Sprints 3/4
aplicaba específicamente a login/logout, no a la navegación normal entre
pantallas de una feature de negocio.

#### Task 1 — Proveedor: DTO y modelo de dominio (`lib/features/proveedores/data/`)

**Qué se implementó:** `ProveedorDto` (freezed + `json_serializable`,
fiel al JSON snake_case de la API) y el modelo de dominio `Proveedor`
(camelCase), con `ProveedorDto.toDomain()` como mapeo — mismo patrón que
`PerfilDto`/`Perfil` (Sprint 3).

**Decisiones:** `tipoId` se incluyó en el modelo (viene de la API) pero
se omitió del formulario de este Sprint — depende del catálogo
compartido `GET /catalogos`, que ninguna feature ha consumido todavía;
esa decisión de arquitectura (dónde vive un recurso compartido entre
features) se pospuso hasta que una segunda feature también lo necesite.
Verificado que `toDomain()` es puramente estructural, sin lógica de
negocio, valores por defecto ni validación.

#### Task 2 — Proveedores: Repository (`lib/features/proveedores/data/datasources/`, `.../repositories/`)

**Qué se implementó:** `ProveedorRemoteDataSource` (`getProveedores()`,
`crear(...)`, `actualizar(id, ...)`) y `ProveedorRepository` (mapea a
`Proveedor`/`List<Proveedor>`, deja pasar `ApiException`/
`NetworkException` sin envolver) — mismo patrón que
`PerfilRemoteDataSource`/`PerfilRepository`.

**Decisiones:** `actualizar()`/`crear()` arman el body solo con los
campos no nulos (`if (campo != null) 'clave': campo`), para no
sobreescribir con `null` un campo que el usuario no quiso cambiar en una
actualización parcial.

#### Task 3 — Providers de Riverpod de la feature (`lib/features/proveedores/presentation/providers/`)

**Qué se implementó:** `proveedorRepositoryProvider`, `proveedoresProvider`
(`FutureProvider<List<Proveedor>>`) y `ProveedorFormController`
(`AsyncNotifier<void>` con `crear(...)`/`actualizar(id, ...)`, cada uno
invalida `proveedoresProvider` al terminar con éxito).

**Decisiones:** se consideró agregar un guard de re-entrancia (como el de
`LogoutController`, Sprint 4) pero se retiró — la regla acordada es
evidence-driven: no se agrega lógica defensiva sin una prueba que
demuestre la condición de carrera, y aquí no había tal prueba.

#### Task 4 — Pantalla de lista de Proveedores (`lib/features/proveedores/presentation/screens/proveedores_list_screen.dart`)

**Qué se implementó:** `ProveedoresListScreen` (`ConsumerWidget`) con los
4 estados de `proveedoresProvider` (loading/error/vacío/datos), edición
condicionada a `perfil.rol == AppRole.adminBodega`, y FAB para crear
(todos los roles).

**Decisiones (arquitectónica, revisada explícitamente):** la pantalla
**no importa `go_router`** — expone `onCrear`/`onEditar` como callbacks,
invocados por el FAB y el tap de cada item. La navegación real (wiring a
`context.push`) se resolvió en Task 6, en la capa de routing, para no
forward-referenciar rutas que aún no existían y mantener la pantalla
testeable sin un `GoRouter` real.

#### Task 5 — Formulario de Proveedor, crear/editar (`lib/features/proveedores/presentation/screens/proveedor_form_screen.dart`)

**Qué se implementó:** `ProveedorFormScreen({Proveedor? proveedorExistente,
required onGuardado})`, un solo formulario reutilizado para ambos modos;
componente de UI puro sobre `ProveedorFormController`; invoca
`onGuardado()` (no `context.pop()` directo) cuando el guardado termina
con éxito.

**Dos bugs reales encontrados y corregidos de forma evidence-driven**
(test primero contra la implementación sin modificar, fix solo tras
verlo fallar):
1. `next.hasValue` no es una señal confiable de éxito en
   `AsyncValue`/Riverpod: el framework preserva el valor anterior a
   través de loading/error (para UIs "sin parpadeo"), así que sigue en
   `true` incluso en un `AsyncError`. La condición correcta para detectar
   éxito es `!next.hasError`.
2. `ProveedorFormController` no era `autoDispose`: un envío fallido dejaba
   su `AsyncError` "pegado" en el provider global, y la siguiente vez que
   se abría el formulario (nueva instancia de pantalla) mostraba de
   entrada el error del intento anterior. Corregido con
   `AsyncNotifierProvider.autoDispose` — su ciclo de vida queda atado
   exclusivamente a `ProveedorFormScreen`.

#### Task 6 — Integración con el Router y entrada desde Home (`lib/core/router/`, `lib/features/dashboard/presentation/screens/home_screen.dart`)

**Qué se implementó:** `RouteNames`/`RoutePaths.proveedores` y
`.proveedorFormulario`; 2 `GoRoute` nuevos en `app_routes.dart` — el de
`/proveedores` construye `ProveedoresListScreen` pasándole
`onCrear`/`onEditar` que llaman `context.push(...)` (con
`extra: proveedor` para editar); el de `/proveedores/formulario` lee
`state.extra as Proveedor?` (`null` = modo crear) y le pasa
`onGuardado: () => context.pop()` a `ProveedorFormScreen`. `HomeScreen`
gana un botón "Proveedores" que navega con
`context.push(RoutePaths.proveedores)`.

**Decisiones:** toda la navegación de la feature vive en
`app_routes.dart`, no en las pantallas — cumple la arquitectura aprobada
en Tasks 4/5. Sin cambios en `AppRouter`/`AuthRedirect`: cualquier ruta
que no sea `login` ya se trata como protegida desde Sprint 2. El botón de
`HomeScreen` es la primera excepción deliberada a "no navega" (Sprint 4):
un `context.push` disparado por una acción real del usuario, no por un
cambio de estado de sesión.

**Validación de las 6 tasks:** `flutter analyze` sin issues y `flutter
test` en verde (88/88) al cierre de cada una y al cierre del Sprint.

---

## Estado del repositorio

- **Rama principal:** `main`, sincronizada con `origin/main` (push de
  Sprint 2, 3, 4 y 5 ya confirmado).
- **Ramas existentes** (todas ya integradas en `main` vía fast-forward, ninguna
  eliminada): `feature/theme-system`, `feature/router-infrastructure`,
  `feature/core-config`, `feature/core-session-service`,
  `feature/core-network-client`, `feature/core-constants-utils`,
  `feature/router-auth-guards`, `feature/app-bootstrap`,
  `feature/auth-core-providers`, `feature/auth-perfil-model`,
  `feature/auth-repositories`, `feature/auth-riverpod-providers`,
  `feature/auth-login-screen`, `feature/auth-router-integration`,
  `feature/dashboard-home-screen`, `feature/dashboard-logout-action`,
  `feature/dashboard-router-integration`, `feature/proveedores-model`,
  `feature/proveedores-repository`, `feature/proveedores-providers`,
  `feature/proveedores-list-screen`, `feature/proveedores-form-screen`,
  `feature/proveedores-router`.
- **Remoto:** `origin` → `https://github.com/JosueJafet/ZUNGOFFEE-MOVIL-APP.git`.
- **Commits de Sprint 2 (historial de `main`, en orden, después de los 11 de
  Sprint 0.5/Sprint 1):**
  1. `feat(config): add environment configuration for Supabase and API`
  2. `chore(config): remove now-unneeded .gitkeep`
  3. `chore(deps): add supabase_flutter dependency`
  4. `feat(services): add Supabase SDK bootstrap`
  5. `feat(services): add AuthSessionService wrapper over Supabase Auth`
  6. `chore(services): remove now-unneeded .gitkeep`
  7. `feat(errors): add ApiException and NetworkException`
  8. `feat(api): add SessionTokenProvider interface, implemented by AuthSessionService`
  9. `feat(api): add centralized Dio client with auth header and error translation`
  10. `test(api): verify ApiClient auth header and error translation`
  11. `chore(api,errors): remove now-unneeded .gitkeep files`
  12. `feat(constants): add EstadoCafeId catalog and valid processing transitions`
  13. `feat(constants): add AppRole and PaginationLimits constants`
  14. `feat(utils): add BigIntId parsing helper`
  15. `feat(utils): add ApiDecimal parsing helper`
  16. `feat(utils): add ApiDate parsing helper`
  17. `chore(constants,utils): remove now-unneeded .gitkeep files`
  18. `feat(router): add login placeholder route`
  19. `feat(router): add pure AuthRedirect decision logic`
  20. `feat(router): add GoRouterRefreshStream to react to auth state changes`
  21. `feat(router): guard routes based on AuthSessionService session state`
  22. `feat(app): wire Supabase bootstrap, AppTheme and AppRouter into main.dart`
  23. `test(router): dispose SupabaseClient to avoid leaking its auto-refresh timer`
- **Commits de Sprint 3 (historial de `main`, en orden, después de los 23 de
  Sprint 2):**
  1. `feat(services): add authSessionServiceProvider`
  2. `feat(api): add apiClientProvider built on authSessionServiceProvider`
  3. `feat(app): build router from a shared ProviderContainer instead of a separate AuthSessionService`
  4. `chore(analysis): ignore invalid_annotation_target false positive from freezed + json_serializable`
  5. `feat(auth): add Perfil domain model`
  6. `feat(auth): add PerfilDto for GET /perfil and mapping to Perfil`
  7. `test(auth): verify PerfilDto parsing and mapping to Perfil`
  8. `feat(auth): add AuthRepository wrapping AuthSessionService`
  9. `feat(auth): add PerfilRemoteDataSource for GET /perfil`
  10. `feat(auth): add PerfilRepository mapping PerfilDto to Perfil`
  11. `feat(auth): add authRepositoryProvider, authStateProvider, isAuthenticatedProvider`
  12. `feat(auth): add perfilRepositoryProvider and perfilProvider`
  13. `feat(auth): add LoginController for the login form submission state`
  14. `feat(auth): add real LoginScreen with form validation and error display`
  15. `test(router): assert LoginScreen renders instead of the removed placeholder`
  16. `feat(router): serve the real LoginScreen on the login route`
- **Commits de Sprint 4 (historial de `main`, en orden, después de los 16
  de Sprint 3, sin contar el commit de documentación de cierre de
  Sprint 3):**
  1. `feat(dashboard): add real HomeScreen consuming perfilProvider`
  2. `feat(auth): add LogoutController for the sign-out action`
  3. `feat(dashboard): wire logout action into HomeScreen`
  4. `test(dashboard): verify two rapid logout taps don't fire signOut() twice`
  5. `fix(auth): guard LogoutController.signOut against concurrent invocation`
  6. `feat(router): serve the real HomeScreen on the home route`
  7. `test(router): assert HomeScreen renders instead of the removed placeholder`
- **Commits de Sprint 5 (historial de `main`, en orden, después de los 7
  de Sprint 4, sin contar el commit de documentación de cierre de
  Sprint 4):**
  1. `feat(proveedores): add Proveedor domain model`
  2. `feat(proveedores): add ProveedorDto for GET/POST/PATCH /proveedores`
  3. `test(proveedores): verify ProveedorDto parsing and mapping to Proveedor`
  4. `feat(proveedores): add ProveedorRemoteDataSource for /proveedores`
  5. `feat(proveedores): add ProveedorRepository`
  6. `feat(proveedores): add proveedorRepositoryProvider and proveedoresProvider`
  7. `feat(proveedores): add ProveedorFormController for crear/actualizar`
  8. `feat(proveedores): add ProveedoresListScreen`
  9. `fix(proveedores): make ProveedorFormController autoDispose`
  10. `feat(proveedores): add ProveedorFormScreen`
  11. `feat(router): wire proveedores routes to GoRouter`
  12. `feat(dashboard): add navigation entry point to Proveedores`

---

## Estructura actual del proyecto

```
lib/
  core/                     Infraestructura transversal (sin lógica de negocio)
    api/                    Cliente Dio + errores tipados — implementado (Sprint 2)
      api_client.dart
      api_providers.dart    apiClientProvider (Sprint 3)
      session_token_provider.dart
    config/                 Configuración de entorno — implementado (Sprint 2)
      app_environment.dart
    constants/              Constantes de dominio — implementado (Sprint 2)
      app_role.dart
      estado_cafe.dart
      pagination_limits.dart
    errors/                 Excepciones tipadas — implementado (Sprint 2)
      api_exception.dart
      network_exception.dart
    router/                 Navegación (GoRouter) — implementado (Sprint 1 + 2)
      app_router.dart       AppRouter.build(AuthSessionService)
      app_routes.dart       login -> LoginScreen (Sprint 3), home -> HomeScreen
                             (Sprint 4), proveedores/proveedorFormulario ->
                             ProveedoresListScreen/ProveedorFormScreen (Sprint 5)
      auth_redirect.dart
      go_router_refresh_stream.dart
      route_names.dart
      route_paths.dart
      screens/              Pantalla placeholder restante (splash)
    services/               Sesión/Supabase — implementado (Sprint 2)
      auth_session_service.dart
      auth_providers.dart   authSessionServiceProvider (Sprint 3)
      supabase_bootstrap.dart
    theme/                  Sistema de theming — implementado (Sprint 1)
    utils/                  Parseo de datos de la API — implementado (Sprint 2)
      api_date.dart
      api_decimal.dart
      bigint_id.dart
  features/                 Un directorio por módulo de negocio, mismo
                             patrón en los 9 módulos: auth, clientes,
                             compras, dashboard, inventario, notificaciones,
                             perfil, procesamiento, proveedores, reportes,
                             ventas.
    auth/                   Implementado (Sprint 3) — login real + perfil
      data/
        datasources/
          perfil_remote_datasource.dart
        dtos/
          perfil_dto.dart
        models/
          perfil.dart
        repositories/
          auth_repository.dart
          perfil_repository.dart
      presentation/
        providers/
          auth_providers.dart      authRepositoryProvider, authStateProvider
          perfil_providers.dart    perfilRepositoryProvider, perfilProvider
          login_controller.dart   loginControllerProvider
        screens/
          login_screen.dart
        widgets/                  (vacío)
    dashboard/                Implementado (Sprint 4) — Home real, más el
                               punto de entrada a Proveedores (Sprint 5)
      data/                       (vacío — no necesitó capa de datos propia)
      presentation/
        providers/                (vacío — usa los providers de auth/)
        screens/
          home_screen.dart
        widgets/                  (vacío)
    proveedores/              Implementado (Sprint 5) — primer módulo de
                               negocio real: listar, crear y editar
      data/
        datasources/
          proveedor_remote_datasource.dart
        dtos/
          proveedor_dto.dart
        models/
          proveedor.dart
        repositories/
          proveedor_repository.dart
      presentation/
        providers/
          proveedor_providers.dart       proveedorRepositoryProvider,
                                          proveedoresProvider
          proveedor_form_controller.dart proveedorFormControllerProvider
                                          (autoDispose)
        screens/
          proveedores_list_screen.dart
          proveedor_form_screen.dart
        widgets/                  (vacío)
    <resto de features>/     Todos vacíos (solo `.gitkeep`), mismo patrón
                              data/{datasources,dtos,models,repositories}
                              y presentation/{providers,screens,widgets}
                              que `auth/`/`dashboard/`/`proveedores/`.
  shared/                   Elementos reutilizables entre features (vacío)
    extensions/
    mixins/
    widgets/
      buttons/ cards/ dialogs/ empty_states/ inputs/ loaders/ snackbars/
  main.dart                 Bootstrap: inicializa Supabase, construye
                             AuthSessionService + AppRouter una vez, y monta
                             MaterialApp.router con AppTheme.
test/
  core/
    api/api_client_test.dart, api_providers_test.dart
    services/auth_providers_test.dart
    constants/estado_cafe_test.dart
    router/app_router_test.dart
    router/auth_redirect_test.dart
    router/app_routes_proveedores_test.dart
    utils/api_date_test.dart, api_decimal_test.dart, bigint_id_test.dart
  features/auth/
    data/dtos/perfil_dto_test.dart
    data/datasources/perfil_remote_datasource_test.dart
    data/repositories/auth_repository_test.dart, perfil_repository_test.dart
    presentation/providers/perfil_providers_test.dart, login_controller_test.dart,
      logout_controller_test.dart
    presentation/screens/login_screen_test.dart
  features/dashboard/
    presentation/screens/home_screen_test.dart
  features/proveedores/
    data/dtos/proveedor_dto_test.dart
    data/datasources/proveedor_remote_datasource_test.dart
    data/repositories/proveedor_repository_test.dart
    presentation/providers/proveedor_providers_test.dart,
      proveedor_form_controller_test.dart
    presentation/screens/proveedores_list_screen_test.dart,
      proveedor_form_screen_test.dart
  widget_test.dart
docs/
  PROJECT_STATUS.md         Este documento
android/, ios/              Scaffolding estándar de `flutter create`
```

---

## Decisiones arquitectónicas

1. **Clean Architecture por feature**, con capas `data/` y `presentation/`
   dentro de cada módulo — sin cambios desde el scaffold inicial.
2. **Riverpod** como gestor de estado oficial, API clásica (sin
   `riverpod_generator`) — primeros providers reales desde Sprint 3
   (`core/` y `features/auth`).
3. **GoRouter** como único sistema de navegación, ahora con guards de sesión
   (`AuthRedirect` + `GoRouterRefreshStream`), sin roles/permisos por ruta
   todavía (eso depende del perfil/rol del usuario, que es trabajo de
   feature).
4. **Sistema de theming basado 100% en la Guía de Marca oficial**, sin
   valores inventados.
5. **Tokens/namespaces como `abstract final class` con miembros estáticos**
   (patrón Dart 3) para todo lo que es configuración pura sin estado
   (`AppTheme`, `AppEnvironment`, `AppRole`, `EstadoCafeId`, etc.).
6. **Excepciones tipadas para errores de API** (`ApiException`/
   `NetworkException`), no Result/Either — decisión explícita para integrar
   sin boilerplate con `AsyncValue.guard` de Riverpod.
7. **Inversión de dependencias en los puntos de integración con SDKs
   externos**: `SessionTokenProvider` (en `core/api`) es implementado por
   `AuthSessionService` (en `core/services`), para que el cliente de red no
   dependa del SDK de Supabase y sea testeable con un fake.
8. **Clases con estado real (que envuelven I/O externo) se inyectan por
   constructor**, rompiendo a propósito el patrón "namespace estático" —
   `AuthSessionService`, `ApiClient` — para permitir tests con fakes/clientes
   de prueba.
9. **`AppRouter` es un builder (`AppRouter.build(authSessionService)`), no
   un campo estático fijo**: necesita una dependencia en tiempo de
   ejecución (la sesión), así que quien ensambla la app decide cuándo
   construirlo — siempre una sola vez, nunca dentro de `build()`.
10. **Sin sistema de flavors dev/staging/prod**: el backend no tiene aún un
    ambiente de producción separado; se sobreescribe la URL vía
    `--dart-define` para desarrollo local contra `localhost:3000`.
11. **Cada tarea de infraestructura se limita estrictamente a su alcance
    declarado** — patrón repetido en las 8 tareas de Sprint 1+2, para
    mantener cada rama pequeña y revisable de forma aislada.
12. **`analysis_options.yaml` usa únicamente `flutter_lints` base**, sin
    reglas adicionales.
13. **Rama principal `main`**, con flujo `feature/*` → merge (fast-forward)
    → `main`, sin eliminar las ramas ya integradas.
14. **La feature `auth` nunca depende del Router ni navega directamente**
    (Sprint 3): el único mecanismo que activa los redirects de `AppRouter`
    sigue siendo el cambio de estado de sesión
    (`AuthSessionService.onAuthStateChange` → `GoRouterRefreshStream`), no
    una llamada explícita desde `LoginScreen`/providers/repositories de la
    feature.
15. **Fakes por herencia en tests, sin mocking framework**: `AuthRepository`/
    `PerfilRepository` no son interfaces, así que los tests que necesitan un
    doble de prueba los subclasifican directamente y sobreescriben solo el
    método necesario (patrón usado en Sprint 3, Tasks 3–5).
16. **La feature `dashboard` extiende la misma regla de no depender del
    Router** (Sprint 4): ni `HomeScreen` ni `LogoutController` navegan ni
    importan `core/router/` — el redirect a `/login` tras el logout sigue
    ocurriendo solo por el cambio de estado de sesión, igual que `auth`.
17. **Guards de re-entrancia en `AsyncNotifier` se ponen en el controller,
    no en el widget** (Sprint 4, `LogoutController.signOut`): el estado se
    actualiza de forma sincrónica al invocar la acción, pero el rebuild
    que deshabilita el control de UI ocurre recién en el siguiente frame
    — un guard `if (state.isLoading) return;` al inicio del método
    protege contra invocaciones repetidas sin depender de ese timing.
18. **Features de negocio "hoja" (con pantallas propias que se navegan
    entre sí) sí pueden navegar directamente vía GoRouter** (Sprint 5,
    `proveedores`) — a diferencia de la regla de Sprints 3/4 (que aplica
    específicamente a login/logue-out, gobernados solo por el estado de
    sesión). Aun así, las pantallas de la feature (`ProveedoresListScreen`,
    `ProveedorFormScreen`) **no importan `go_router`**: exponen callbacks
    (`onCrear`/`onEditar`/`onGuardado`) y es la capa de routing
    (`app_routes.dart`) la que decide cuándo hacer `context.push`/`pop` —
    mantiene las pantallas testeables sin un `GoRouter` real y evita que
    una Task de pantalla dependa de rutas que otra Task todavía no creó.
19. **`AsyncValue.hasValue` no es una señal confiable de "esta operación
    tuvo éxito"** (Sprint 5, bug real encontrado en `ProveedorFormScreen`):
    Riverpod preserva el valor anterior a través de transiciones de
    loading/error (para UIs "sin parpadeo"), así que `hasValue` sigue en
    `true` incluso en un `AsyncError`. La señal correcta para "esta
    operación específica tuvo éxito" es `!next.hasError` (o
    `next is AsyncData`), comparado contra el `previous.isLoading` que
    inició esa operación.
20. **Providers de formulario que se montan una vez por pantalla deben ser
    `autoDispose`** (Sprint 5, `ProveedorFormController`): sin
    `autoDispose`, el estado de un envío fallido sobrevive al cerrar la
    pantalla y se filtra a la siguiente vez que se abre el mismo
    formulario. Confirmado con un test de regresión (push/pop real vía
    `Navigator`) antes de aplicar el fix — el mismo patrón evidence-driven
    de la Decisión 17.

---

## Pendientes

Lo que falta por implementar, en el orden en que fue quedando pendiente:

- **`.metadata` con las entradas `android`/`ios` eliminadas y `windows/`
  sin commitear**: efecto secundario de `flutter create --platforms=windows .`
  (ejecutado para poder correr la app en Windows Desktop durante una
  verificación visual manual). Confirmado que es comportamiento esperado
  del propio comando (reescribe `migration.platforms` solo con lo pasado
  en `--platforms`) y que no afecta las carpetas `android/`/`ios/` reales.
  Queda deliberadamente sin resolver/commitear hasta que el usuario
  decida si restaurar esas entradas o dejarlo así.
- **Application ID / Bundle ID siguen siendo placeholders**:
  `com.example.zungofee_mobile` (Android) y `com.example.zungofeeMobile`
  (iOS). Detectado en Sprint 0, no resuelto en ningún sprint posterior.
- **Firma de release de Android** sigue usando `signingConfigs.debug`. No
  resuelto.
- **La Guía de Marca (PDF) y el contexto técnico del backend
  (`CONTEXTO-MOVIL-FLUTTER.md`) no están versionados en el repositorio** —
  ambos fueron compartidos directamente en la conversación. Se recomienda
  guardarlos en `docs/` para que no dependan del historial de chat.
- **Registro de fuentes de marca** (`Poppins`, `Inter`, `JetBrains Mono`) en
  `pubspec.yaml` (`flutter.fonts`) y sus archivos `.ttf`: nombres declarados,
  assets no agregados.
- **Botón "soft destructivo"** del mock de la Guía de Marca sigue sin
  equivalente en el theme; pendiente para `shared/widgets/buttons`.
- **`features/auth`, `features/dashboard` y `features/proveedores` son los
  únicos módulos con código** — el resto de `features/*` (clientes,
  compras, inventario, notificaciones, perfil, procesamiento, reportes,
  ventas) sigue vacío.
- **`shared/` completo** (extensions, mixins, widgets) sigue vacío —
  ninguna Task de Sprint 3, 4 ni 5 encontró duplicación real que
  justificara empezarlo.
- **Edición de perfil** (`PATCH /perfil`): fuera de alcance;
  `Perfil`/`PerfilRepository` solo cubren lectura (`GET /perfil`).
- **Diálogo de confirmación antes de logout**: decisión explícita de
  dejarlo fuera de Sprint 4; el botón ejecuta `signOut()` de inmediato.
- **Guards por rol en el router**: sigue distinguiendo solo autenticado/no
  autenticado, no por rol — depende de leer `perfilProvider` desde el
  router o un guard equivalente, no diseñado todavía.
- **`tipoId` de `Proveedor` sin selector en el formulario**: la feature
  `proveedores` (Sprint 5) omitió deliberadamente ese campo del
  formulario — depende de `GET /catalogos` (`proveedoresTipo`), que
  ninguna feature ha consumido todavía; queda pendiente decidir dónde
  vive un catálogo compartido entre features cuando una segunda feature
  (`compras`, `ventas`, `clientes`) también lo necesite.
- **Eliminar/desactivar proveedor, búsqueda, filtros, paginación**: no
  documentados para `/proveedores` en el contrato actual, fuera de
  alcance de Sprint 5.
- **Cola de operaciones offline / reintentos de red en campo**: mencionado
  en el contexto técnico como decisión futura, no abordado todavía.
- **Registro de dispositivo push** (`firebase_messaging`,
  `POST /notificaciones/dispositivos`): el propio backend aclara que el
  envío real de push no está conectado del lado servidor todavía; no es
  prioritario.

---

## Próximo Sprint recomendado

**Aún no diseñado.** Con `auth`, `dashboard` (Home) y `proveedores`
completos, los candidatos naturales son: **guards por rol en el router**
(ya se puede leer `perfilProvider.rol` para distinguir `empleado`/
`admin_bodega`/`super_admin`), o el **segundo módulo de negocio real**
(`compras`, que depende de que existan proveedores registrados —
ya lo están; `clientes`, mismo patrón que `proveedores`; o
`inventario`), según la prioridad de negocio. Este alcance no ha sido
diseñado ni aprobado — cuando se decida, corresponde repetir el mismo
proceso de diseño de Sprint (desglose en Tasks, revisión antes de
implementar).

No perder de vista los pendientes de configuración nativa (Application
ID, firma de release) — no bloquean el próximo Sprint, pero deben
resolverse antes de cualquier build de distribución real.

---

## Información importante

El backend oficial (staging) ya está desplegado y la app está integrada
contra él desde Sprint 2 — la pausa que motivó `CONTEXTO-MOVIL-FLUTTER.md`
ya se resolvió. Sigue aplicando el principio de fondo: **la app debe
adaptarse al backend existente, no al revés**. Cualquier estructura de
datos, endpoint, regla de negocio o estado (`estados_cafe`, roles, límites de
paginación, formato de IDs/decimales/fechas) debe tomarse del contrato ya
documentado en `CONTEXTO-MOVIL-FLUTTER.md` — no inventar ni anticipar campos
o comportamientos que ese documento no confirme. Si el contrato cambia
(nuevo endpoint, campo, regla), este documento y el código de `core/`
deben actualizarse juntos, no solo uno de los dos.

Nota sobre el ambiente: `https://zungo-coffee-api.onrender.com` sigue siendo
**staging**, con cold start de ~30-50s tras inactividad (plan free de
Render) — no hay todavía un ambiente de producción separado.

---

## Próximo Hito

**Sprint 3 (autenticación), Sprint 4 (Home/Dashboard) y Sprint 5
(Proveedores, primer módulo de negocio real) ya se completaron** — ver
detalle en "Sprints completados" y en "Próximo Sprint recomendado" para
lo que sigue (aún sin diseñar formalmente).
