import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import '../../../../support/fake_session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/bodegas/data/datasources/bodega_remote_datasource.dart';
import 'package:zungofee_mobile/features/bodegas/data/models/bodega.dart';
import 'package:zungofee_mobile/features/bodegas/data/repositories/bodega_repository.dart';
import 'package:zungofee_mobile/features/bodegas/presentation/providers/bodega_providers.dart';
import 'package:zungofee_mobile/features/bodegas/presentation/screens/bodega_form_screen.dart';

class _FakeBodegaRepository extends BodegaRepository {
  _FakeBodegaRepository({this.onboardingError, this.actualizarNombreError})
    : super(BodegaRemoteDataSource(ApiClient(FakeSessionTokenProvider())));

  final Object? onboardingError;
  final Object? actualizarNombreError;

  int onboardingCallCount = 0;
  int actualizarNombreCallCount = 0;
  Map<String, dynamic>? ultimoOnboarding;
  Map<String, dynamic>? ultimoActualizar;

  static final _bodegaGuardada = Bodega(
    id: 99,
    nombre: 'Bodega Guardada',
    estadoId: 1,
    fechaRegistro: DateTime.parse('2026-07-21T00:00:00.000Z'),
  );

  @override
  Future<Bodega> onboarding({
    required String nombreBodega,
    required String emailAdmin,
    required String passwordAdmin,
    required String nombreAdmin,
    int? solicitudId,
  }) async {
    onboardingCallCount++;
    ultimoOnboarding = {
      'nombreBodega': nombreBodega,
      'emailAdmin': emailAdmin,
      'passwordAdmin': passwordAdmin,
      'nombreAdmin': nombreAdmin,
    };
    if (onboardingError != null) throw onboardingError!;
    return _bodegaGuardada;
  }

  @override
  Future<Bodega> actualizarNombre(int id, {required String nombre}) async {
    actualizarNombreCallCount++;
    ultimoActualizar = {'id': id, 'nombre': nombre};
    if (actualizarNombreError != null) throw actualizarNombreError!;
    return _bodegaGuardada;
  }

  @override
  Future<List<Bodega>> getBodegas() async => [];
}

final _bodegaExistente = Bodega(
  id: 5,
  nombre: 'Bodega de Prueba',
  estadoId: 1,
  fechaRegistro: DateTime.parse('2026-07-21T00:00:00.000Z'),
);

Widget _wrap(
  BodegaRepository repository, {
  Bodega? bodegaExistente,
  VoidCallback? onGuardado,
}) {
  return ProviderScope(
    overrides: [bodegaRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.light,
      home: BodegaFormScreen(
        bodegaExistente: bodegaExistente,
        onGuardado: onGuardado ?? () {},
      ),
    ),
  );
}

void main() {
  group('BodegaFormScreen', () {
    testWidgets('modo crear: muestra los 4 campos de onboarding', (tester) async {
      await tester.pumpWidget(_wrap(_FakeBodegaRepository()));

      expect(find.widgetWithText(AppBar, 'Nueva bodega'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Nombre de la bodega'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Nombre del admin'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Correo del admin'), findsOneWidget);
      expect(find.widgetWithText(TextFormField, 'Contraseña del admin'), findsOneWidget);
    });

    testWidgets('modo crear: no envía el submit si los campos están vacíos', (
      tester,
    ) async {
      final repository = _FakeBodegaRepository();

      await tester.pumpWidget(_wrap(repository));

      await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
      await tester.pumpAndSettle();

      expect(repository.onboardingCallCount, 0);
      expect(find.text('Ingresa el nombre'), findsNWidgets(2));
      expect(find.text('Ingresa el correo'), findsOneWidget);
      expect(find.text('Ingresa la contraseña'), findsOneWidget);
    });

    testWidgets('modo crear: contraseña de menos de 8 caracteres no pasa', (
      tester,
    ) async {
      final repository = _FakeBodegaRepository();

      await tester.pumpWidget(_wrap(repository));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre de la bodega'),
        'Bodega Nueva',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre del admin'),
        'Admin Nuevo',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Correo del admin'),
        'admin@bodeganueva.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Contraseña del admin'),
        'corta',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
      await tester.pumpAndSettle();

      expect(repository.onboardingCallCount, 0);
      expect(find.text('Mínimo 8 caracteres'), findsOneWidget);
    });

    testWidgets(
      'modo crear: éxito llama onboarding() con los valores ingresados y '
      'llama onGuardado',
      (tester) async {
        final repository = _FakeBodegaRepository();
        var guardadoCallCount = 0;

        await tester.pumpWidget(
          _wrap(repository, onGuardado: () => guardadoCallCount++),
        );

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nombre de la bodega'),
          'Bodega Nueva',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nombre del admin'),
          'Admin Nuevo',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Correo del admin'),
          'admin@bodeganueva.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Contraseña del admin'),
          'password123',
        );
        await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
        await tester.pumpAndSettle();

        expect(repository.onboardingCallCount, 1);
        expect(repository.ultimoOnboarding?['nombreBodega'], 'Bodega Nueva');
        expect(repository.ultimoOnboarding?['nombreAdmin'], 'Admin Nuevo');
        expect(
          repository.ultimoOnboarding?['emailAdmin'],
          'admin@bodeganueva.com',
        );
        expect(repository.ultimoOnboarding?['passwordAdmin'], 'password123');
        expect(guardadoCallCount, 1);
        expect(find.text('Bodega creada con éxito.'), findsOneWidget);
      },
    );

    testWidgets(
      'modo editar: solo muestra el campo de nombre, prellenado',
      (tester) async {
        await tester.pumpWidget(
          _wrap(_FakeBodegaRepository(), bodegaExistente: _bodegaExistente),
        );

        expect(find.widgetWithText(AppBar, 'Editar bodega'), findsOneWidget);
        expect(find.text('Bodega de Prueba'), findsOneWidget);
        expect(
          find.widgetWithText(TextFormField, 'Nombre del admin'),
          findsNothing,
        );
        expect(
          find.widgetWithText(TextFormField, 'Correo del admin'),
          findsNothing,
        );
        expect(
          find.widgetWithText(TextFormField, 'Contraseña del admin'),
          findsNothing,
        );
      },
    );

    testWidgets(
      'modo editar: éxito llama actualizarNombre(id, ...) y llama onGuardado',
      (tester) async {
        final repository = _FakeBodegaRepository();
        var guardadoCallCount = 0;

        await tester.pumpWidget(
          _wrap(
            repository,
            bodegaExistente: _bodegaExistente,
            onGuardado: () => guardadoCallCount++,
          ),
        );

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nombre de la bodega'),
          'Nombre Editado',
        );
        await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
        await tester.pumpAndSettle();

        expect(repository.actualizarNombreCallCount, 1);
        expect(repository.ultimoActualizar?['id'], 5);
        expect(repository.ultimoActualizar?['nombre'], 'Nombre Editado');
        expect(guardadoCallCount, 1);
        expect(find.text('Bodega actualizada con éxito.'), findsOneWidget);
      },
    );

    testWidgets('un error de la API se muestra inline y no llama onGuardado', (
      tester,
    ) async {
      final repository = _FakeBodegaRepository(
        onboardingError: const ApiException(
          statusCode: 400,
          message: 'El correo ya está registrado',
        ),
      );
      var guardadoCallCount = 0;

      await tester.pumpWidget(
        _wrap(repository, onGuardado: () => guardadoCallCount++),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre de la bodega'),
        'Bodega Nueva',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre del admin'),
        'Admin Nuevo',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Correo del admin'),
        'admin@bodeganueva.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Contraseña del admin'),
        'password123',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
      await tester.pumpAndSettle();

      expect(find.text('El correo ya está registrado'), findsOneWidget);
      expect(guardadoCallCount, 0);
    });

    testWidgets(
      'modo editar: un error de la API se muestra inline y no llama '
      'onGuardado',
      (tester) async {
        final repository = _FakeBodegaRepository(
          actualizarNombreError: const ApiException(
            statusCode: 403,
            message: 'Forbidden resource',
          ),
        );
        var guardadoCallCount = 0;

        await tester.pumpWidget(
          _wrap(
            repository,
            bodegaExistente: _bodegaExistente,
            onGuardado: () => guardadoCallCount++,
          ),
        );

        await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
        await tester.pumpAndSettle();

        expect(find.text('Forbidden resource'), findsOneWidget);
        expect(guardadoCallCount, 0);
      },
    );

    testWidgets('toggle de mostrar/ocultar contraseña', (tester) async {
      await tester.pumpWidget(_wrap(_FakeBodegaRepository()));

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Contraseña del admin'),
        'password123',
      );

      TextField textField() => tester.widget<TextField>(
        find.descendant(
          of: find.widgetWithText(TextFormField, 'Contraseña del admin'),
          matching: find.byType(TextField),
        ),
      );

      expect(textField().obscureText, isTrue);

      await tester.tap(find.byTooltip('Mostrar contraseña'));
      await tester.pump();

      expect(textField().obscureText, isFalse);
    });
  });
}
