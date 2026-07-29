import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/services/foto_picker_providers.dart';
import 'package:zungofee_mobile/core/services/foto_picker_service.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/auth/data/datasources/perfil_remote_datasource.dart';
import 'package:zungofee_mobile/features/auth/data/models/perfil.dart';
import 'package:zungofee_mobile/features/auth/data/repositories/perfil_repository.dart';
import 'package:zungofee_mobile/features/auth/presentation/providers/perfil_providers.dart';
import 'package:zungofee_mobile/features/auth/presentation/screens/perfil_editar_screen.dart';
import 'package:zungofee_mobile/features/pagos/data/datasources/pago_remote_datasource.dart';
import 'package:zungofee_mobile/features/pagos/data/models/pago.dart';
import 'package:zungofee_mobile/features/pagos/data/repositories/pago_repository.dart';
import 'package:zungofee_mobile/features/pagos/presentation/providers/pago_providers.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

final _perfil = Perfil(
  id: 7,
  nombre: 'Juan Pérez',
  activo: true,
  fechaCreacion: DateTime.parse('2026-01-15T10:30:00.000Z'),
  rol: 'empleado',
  tenantId: 3,
  tenantNombre: 'Bodega Central',
);

final _perfilConFoto = _perfil.copyWith(
  fotoUrl: 'https://example.test/avatars/7?t=1753660000000',
);

class _FakePerfilRepository extends PerfilRepository {
  _FakePerfilRepository({
    this.actualizarError,
    this.subirFotoError,
    this.eliminarFotoError,
    Perfil? perfilInicial,
  })  : _perfilActual = perfilInicial ?? _perfil,
        super(PerfilRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Object? actualizarError;
  final Object? subirFotoError;
  final Object? eliminarFotoError;
  int actualizarCallCount = 0;
  int subirFotoCallCount = 0;
  int eliminarFotoCallCount = 0;
  String? ultimoNombre;
  Perfil _perfilActual;

  @override
  Future<Perfil> getPerfil() async => _perfilActual;

  @override
  Future<void> actualizar(String nombre) async {
    actualizarCallCount++;
    ultimoNombre = nombre;
    if (actualizarError != null) throw actualizarError!;
  }

  @override
  Future<Perfil> subirFoto({
    required List<int> bytes,
    required String nombreArchivo,
  }) async {
    subirFotoCallCount++;
    if (subirFotoError != null) throw subirFotoError!;
    _perfilActual = _perfilConFoto;
    return _perfilActual;
  }

  @override
  Future<Perfil> eliminarFoto() async {
    eliminarFotoCallCount++;
    if (eliminarFotoError != null) throw eliminarFotoError!;
    _perfilActual = _perfil;
    return _perfilActual;
  }
}

class _FakePagoRepository extends PagoRepository {
  _FakePagoRepository(this._pagos, {this.error})
      : super(PagoRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final List<Pago> _pagos;
  final Object? error;

  @override
  Future<List<Pago>> getHistorialPorBodega(int tenantId) async {
    if (error != null) throw error!;
    return _pagos;
  }
}

/// Fake de [FotoPickerService]: nunca toca el platform channel real de
/// `image_picker`/`image_cropper` — simula la elección (o cancelación)
/// del usuario.
class _FakeFotoPickerService implements FotoPickerService {
  _FakeFotoPickerService({this.foto});

  final FotoSeleccionada? foto;
  int seleccionarCallCount = 0;
  FuenteFoto? ultimaFuente;

  @override
  Future<FotoSeleccionada?> seleccionarYRecortar(FuenteFoto fuente) async {
    seleccionarCallCount++;
    ultimaFuente = fuente;
    return foto;
  }
}

Widget _wrap(
  PerfilRepository repository, {
  VoidCallback? onGuardado,
  FotoPickerService? fotoPickerService,
  PagoRepository? pagoRepository,
}) {
  return ProviderScope(
    overrides: [
      perfilRepositoryProvider.overrideWithValue(repository),
      fotoPickerServiceProvider.overrideWithValue(
        fotoPickerService ?? _FakeFotoPickerService(),
      ),
      pagoRepositoryProvider.overrideWithValue(
        pagoRepository ?? _FakePagoRepository(const []),
      ),
    ],
    child: MaterialApp(
      theme: AppTheme.light,
      home: PerfilEditarScreen(onGuardado: onGuardado ?? () {}),
    ),
  );
}

void main() {
  group('PerfilEditarScreen', () {
    testWidgets('precarga el campo con el nombre actual del perfil', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(_FakePerfilRepository()));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextFormField, 'Juan Pérez'), findsOneWidget);
    });

    testWidgets(
      'éxito: llama actualizar() con el nombre editado y llama onGuardado',
      (tester) async {
        final repository = _FakePerfilRepository();
        var guardadoCallCount = 0;

        await tester.pumpWidget(
          _wrap(repository, onGuardado: () => guardadoCallCount++),
        );
        await tester.pumpAndSettle();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Juan Pérez'),
          'Nuevo Nombre',
        );
        await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
        await tester.pumpAndSettle();

        expect(repository.actualizarCallCount, 1);
        expect(repository.ultimoNombre, 'Nuevo Nombre');
        expect(guardadoCallCount, 1);
        expect(find.text('Perfil actualizado con éxito.'), findsOneWidget);
      },
    );

    testWidgets('validación: no envía el submit si el nombre queda vacío', (
      tester,
    ) async {
      final repository = _FakePerfilRepository();

      await tester.pumpWidget(_wrap(repository));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Juan Pérez'),
        '   ',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
      await tester.pumpAndSettle();

      expect(find.text('Ingresa el nombre'), findsOneWidget);
      expect(repository.actualizarCallCount, 0);
    });

    testWidgets(
      'un error de la API se muestra inline y no llama onGuardado',
      (tester) async {
        final repository = _FakePerfilRepository(
          actualizarError: const ApiException(
            statusCode: 400,
            message: 'Nombre inválido',
          ),
        );
        var guardadoCallCount = 0;

        await tester.pumpWidget(
          _wrap(repository, onGuardado: () => guardadoCallCount++),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
        await tester.pumpAndSettle();

        expect(find.text('Nombre inválido'), findsOneWidget);
        expect(guardadoCallCount, 0);
      },
    );

    testWidgets('sin foto: el avatar muestra la inicial del nombre', (
      tester,
    ) async {
      await tester.pumpWidget(_wrap(_FakePerfilRepository()));
      await tester.pumpAndSettle();

      expect(find.text('J'), findsOneWidget);
    });

    testWidgets(
      'éxito: "Elegir de galería" sube la foto elegida y muestra '
      'confirmación',
      (tester) async {
        final repository = _FakePerfilRepository();
        final fotoPickerService = _FakeFotoPickerService(
          foto: const FotoSeleccionada(
              bytes: [1, 2, 3], nombreArchivo: 'foto.jpg'),
        );

        // El perfil recargado tras el éxito trae `fotoUrl` no nula — el
        // `CircleAvatar` la pinta con `NetworkImage`, que necesita esta
        // simulación (`flutter_test` no permite tráfico de red real).
        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(
            _wrap(repository, fotoPickerService: fotoPickerService),
          );
          await tester.pumpAndSettle();

          await tester.tap(find.byIcon(Icons.camera_alt));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Elegir de galería'));
          await tester.pumpAndSettle();
        });

        expect(fotoPickerService.seleccionarCallCount, 1);
        expect(fotoPickerService.ultimaFuente, FuenteFoto.galeria);
        expect(repository.subirFotoCallCount, 1);
        expect(find.text('Foto de perfil actualizada.'), findsOneWidget);
      },
    );

    testWidgets('"Tomar foto" usa la cámara', (tester) async {
      final repository = _FakePerfilRepository();
      final fotoPickerService = _FakeFotoPickerService(
        foto:
            const FotoSeleccionada(bytes: [1, 2, 3], nombreArchivo: 'foto.jpg'),
      );

      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(
          _wrap(repository, fotoPickerService: fotoPickerService),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.camera_alt));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Tomar foto'));
        await tester.pumpAndSettle();
      });

      expect(fotoPickerService.ultimaFuente, FuenteFoto.camara);
      expect(repository.subirFotoCallCount, 1);
    });

    testWidgets(
      'cerrar el selector de opciones sin elegir nada no llama al picker',
      (tester) async {
        final repository = _FakePerfilRepository();
        final fotoPickerService = _FakeFotoPickerService();

        await tester.pumpWidget(
          _wrap(repository, fotoPickerService: fotoPickerService),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.camera_alt));
        await tester.pumpAndSettle();
        // Tocar fuera del bottom sheet (el scrim) lo cierra sin elegir
        // ninguna opción — `showModalBottomSheet` es dismissible por
        // defecto.
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        expect(fotoPickerService.seleccionarCallCount, 0);
        expect(repository.subirFotoCallCount, 0);
      },
    );

    testWidgets(
      'cancelar la selección en el picker no llama subirFoto',
      (tester) async {
        final repository = _FakePerfilRepository();
        final fotoPickerService = _FakeFotoPickerService();

        await tester.pumpWidget(
          _wrap(repository, fotoPickerService: fotoPickerService),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.camera_alt));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Elegir de galería'));
        await tester.pumpAndSettle();

        expect(fotoPickerService.seleccionarCallCount, 1);
        expect(repository.subirFotoCallCount, 0);
      },
    );

    testWidgets(
      'un error al subir la foto se muestra inline',
      (tester) async {
        final repository = _FakePerfilRepository(
          subirFotoError: const ApiException(
            statusCode: 400,
            message: 'Formato de imagen no soportado',
          ),
        );
        final fotoPickerService = _FakeFotoPickerService(
          foto: const FotoSeleccionada(
              bytes: [1, 2, 3], nombreArchivo: 'foto.gif'),
        );

        await tester.pumpWidget(
          _wrap(repository, fotoPickerService: fotoPickerService),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.camera_alt));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Elegir de galería'));
        await tester.pumpAndSettle();

        expect(find.text('Formato de imagen no soportado'), findsOneWidget);
      },
    );

    testWidgets(
      'sin foto: el selector de opciones no muestra "Eliminar foto"',
      (tester) async {
        await tester.pumpWidget(_wrap(_FakePerfilRepository()));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.camera_alt));
        await tester.pumpAndSettle();

        expect(find.text('Eliminar foto'), findsNothing);
      },
    );

    testWidgets(
      'con foto: "Eliminar foto" pide confirmación y, al aceptar, borra '
      'la foto',
      (tester) async {
        final repository = _FakePerfilRepository(perfilInicial: _perfilConFoto);

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(_wrap(repository));
          await tester.pumpAndSettle();

          await tester.tap(find.byIcon(Icons.camera_alt));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Eliminar foto'));
          await tester.pumpAndSettle();

          expect(
              find.text('¿Eliminar tu foto de perfil? Vas a volver a '
                  'ver el ícono con tu inicial.'),
              findsOneWidget);

          await tester.tap(find.widgetWithText(FilledButton, 'Eliminar'));
          await tester.pumpAndSettle();
        });

        expect(repository.eliminarFotoCallCount, 1);
        expect(find.text('Foto de perfil eliminada.'), findsOneWidget);
        expect(find.text('J'), findsOneWidget);
      },
    );

    testWidgets(
      'con foto: cancelar el diálogo de "Eliminar foto" no borra nada',
      (tester) async {
        final repository = _FakePerfilRepository(perfilInicial: _perfilConFoto);

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(_wrap(repository));
          await tester.pumpAndSettle();

          await tester.tap(find.byIcon(Icons.camera_alt));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Eliminar foto'));
          await tester.pumpAndSettle();

          await tester.tap(find.widgetWithText(TextButton, 'Cancelar'));
          await tester.pumpAndSettle();
        });

        expect(repository.eliminarFotoCallCount, 0);
      },
    );

    testWidgets(
      'un error al eliminar la foto se muestra inline',
      (tester) async {
        final repository = _FakePerfilRepository(
          perfilInicial: _perfilConFoto,
          eliminarFotoError: const ApiException(
            statusCode: 401,
            message: 'Unauthorized',
          ),
        );

        await mockNetworkImagesFor(() async {
          await tester.pumpWidget(_wrap(repository));
          await tester.pumpAndSettle();

          await tester.tap(find.byIcon(Icons.camera_alt));
          await tester.pumpAndSettle();
          await tester.tap(find.text('Eliminar foto'));
          await tester.pumpAndSettle();

          await tester.tap(find.widgetWithText(FilledButton, 'Eliminar'));
          await tester.pumpAndSettle();
        });

        expect(find.text('Unauthorized'), findsOneWidget);
      },
    );

    testWidgets(
      'admin_bodega: muestra el bloque de Suscripción con el estado y '
      'los días restantes del ciclo vigente',
      (tester) async {
        final perfilAdminBodega = _perfil.copyWith(
          rol: 'admin_bodega',
          tenantId: 9,
        );

        await tester.pumpWidget(
          _wrap(
            _FakePerfilRepository(perfilInicial: perfilAdminBodega),
            pagoRepository: _FakePagoRepository([
              Pago(
                id: 1,
                tenantId: 9,
                periodo: DateTime.utc(2026, 7, 1),
                monto: 500,
                fechaVencimiento: DateTime.now().toUtc().add(
                      const Duration(days: 10),
                    ),
                estadoPagoId: 1,
                registradoPor: 1,
                estadoCalculado: 'pendiente',
              ),
            ]),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Suscripción'), findsOneWidget);
        expect(find.text('pendiente'), findsOneWidget);
        expect(find.textContaining('días restantes'), findsOneWidget);
      },
    );

    testWidgets(
      'admin_bodega: sin ciclos de pago muestra "Sin ciclo de pago '
      'registrado"',
      (tester) async {
        final perfilAdminBodega = _perfil.copyWith(
          rol: 'admin_bodega',
          tenantId: 9,
        );

        await tester.pumpWidget(
          _wrap(
            _FakePerfilRepository(perfilInicial: perfilAdminBodega),
            pagoRepository: _FakePagoRepository(const []),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Sin ciclo de pago registrado'), findsOneWidget);
      },
    );

    testWidgets(
      'admin_bodega: un error al cargar la suscripción se muestra sin '
      'bloquear el resto de la pantalla',
      (tester) async {
        final perfilAdminBodega = _perfil.copyWith(
          rol: 'admin_bodega',
          tenantId: 9,
        );

        await tester.pumpWidget(
          _wrap(
            _FakePerfilRepository(perfilInicial: perfilAdminBodega),
            pagoRepository: _FakePagoRepository(
              const [],
              error: const ApiException(
                statusCode: 500,
                message: 'Error del servidor',
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(
          find.text('No se pudo cargar el estado de la suscripción.'),
          findsOneWidget,
        );
        // El resto de la pantalla (nombre editable) sigue funcionando.
        expect(
            find.widgetWithText(TextFormField, 'Juan Pérez'), findsOneWidget);
      },
    );

    testWidgets(
      'empleado: no muestra el bloque de Suscripción',
      (tester) async {
        await tester.pumpWidget(_wrap(_FakePerfilRepository()));
        await tester.pumpAndSettle();

        expect(find.text('Suscripción'), findsNothing);
      },
    );
  });
}
