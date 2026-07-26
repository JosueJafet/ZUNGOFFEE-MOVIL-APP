import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/errors/network_exception.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/notificaciones/data/datasources/notificaciones_remote_datasource.dart';
import 'package:zungofee_mobile/features/notificaciones/data/models/notificacion.dart';
import 'package:zungofee_mobile/features/notificaciones/data/repositories/notificaciones_repository.dart';
import 'package:zungofee_mobile/features/notificaciones/presentation/providers/notificaciones_providers.dart';
import 'package:zungofee_mobile/features/notificaciones/presentation/screens/notificaciones_list_screen.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

/// Responde con la próxima función de [_responses] en cada llamada — mismo
/// patrón de `existencias_list_screen_test.dart`.
class _FakeNotificacionesRepository extends NotificacionesRepository {
  _FakeNotificacionesRepository(this._responses, {this.marcarLeidaError})
    : super(
        NotificacionesRemoteDataSource(ApiClient(_FakeSessionTokenProvider())),
      );

  final List<Future<List<Notificacion>> Function()> _responses;
  final Object? marcarLeidaError;
  int listarCallCount = 0;
  int marcarLeidaCallCount = 0;

  @override
  Future<List<Notificacion>> listar({int page = 1, int pageSize = 50}) {
    final index = listarCallCount < _responses.length
        ? listarCallCount
        : _responses.length - 1;
    listarCallCount++;
    return _responses[index]();
  }

  @override
  Future<void> marcarLeida(String id) async {
    marcarLeidaCallCount++;
    if (marcarLeidaError != null) throw marcarLeidaError!;
  }
}

const _noLeida = Notificacion(
  id: '3',
  titulo: 'Compra registrada',
  mensaje: 'Se registró una compra de 10 quintales',
  leida: false,
);

const _leida = Notificacion(
  id: '4',
  titulo: 'Venta registrada',
  mensaje: 'Se registró una venta de 5 libras',
  leida: true,
);

Widget _wrap(NotificacionesRepository repository) {
  return ProviderScope(
    overrides: [notificacionesRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.light,
      home: const NotificacionesListScreen(),
    ),
  );
}

void main() {
  group('NotificacionesListScreen', () {
    testWidgets(
      'lista con datos: muestra título y mensaje, con distinción visual '
      'entre leída y no leída',
      (tester) async {
        await tester.pumpWidget(
          _wrap(
            _FakeNotificacionesRepository([
              () async => [_noLeida, _leida],
            ]),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Compra registrada'), findsOneWidget);
        expect(find.text('Se registró una compra de 10 quintales'), findsOneWidget);
        expect(find.text('Venta registrada'), findsOneWidget);

        final tituloNoLeido = tester.widget<Text>(
          find.text('Compra registrada'),
        );
        final tituloLeido = tester.widget<Text>(find.text('Venta registrada'));
        expect(tituloNoLeido.style?.fontWeight, FontWeight.bold);
        expect(tituloLeido.style?.fontWeight, FontWeight.normal);

        // Solo la no leída muestra el indicador visual (ícono leading).
        expect(find.byIcon(Icons.circle), findsOneWidget);
      },
    );

    testWidgets('lista vacía: muestra el mensaje de "sin notificaciones"', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(_FakeNotificacionesRepository([() async => []])),
      );
      await tester.pumpAndSettle();

      expect(find.text('No hay notificaciones'), findsOneWidget);
    });

    testWidgets('un ApiException al cargar muestra su mensaje y reintentar', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          _FakeNotificacionesRepository([
            () async => throw const ApiException(
              statusCode: 500,
              message: 'Error del servidor',
            ),
          ]),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Error del servidor'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Reintentar'), findsOneWidget);
    });

    testWidgets('un NetworkException al cargar muestra su mensaje', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          _FakeNotificacionesRepository([
            () async => throw const NetworkException('Sin conexión'),
          ]),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sin conexión'), findsOneWidget);
    });

    testWidgets(
      'tocar una notificación no leída llama marcarLeida y refresca la lista',
      (tester) async {
        final repository = _FakeNotificacionesRepository([
          () async => [_noLeida],
          () async => [_leida],
        ]);

        await tester.pumpWidget(_wrap(repository));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Compra registrada'));
        await tester.pumpAndSettle();

        expect(repository.marcarLeidaCallCount, 1);
        expect(repository.listarCallCount, 2);
      },
    );

    testWidgets('tocar una notificación ya leída no llama marcarLeida', (
      tester,
    ) async {
      final repository = _FakeNotificacionesRepository([
        () async => [_leida],
      ]);

      await tester.pumpWidget(_wrap(repository));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Venta registrada'));
      await tester.pumpAndSettle();

      expect(repository.marcarLeidaCallCount, 0);
    });

    testWidgets('un error al marcar como leída se muestra en un SnackBar', (
      tester,
    ) async {
      final repository = _FakeNotificacionesRepository(
        [() async => [_noLeida]],
        marcarLeidaError: const ApiException(
          statusCode: 404,
          message: 'Notificación no encontrada',
        ),
      );

      await tester.pumpWidget(_wrap(repository));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Compra registrada'));
      await tester.pumpAndSettle();

      expect(find.text('Notificación no encontrada'), findsOneWidget);
    });
  });
}
