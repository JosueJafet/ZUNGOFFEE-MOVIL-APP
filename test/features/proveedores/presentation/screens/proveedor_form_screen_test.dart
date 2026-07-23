import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/errors/api_exception.dart';
import 'package:zungofee_mobile/core/theme/app_theme.dart';
import 'package:zungofee_mobile/features/proveedores/data/datasources/proveedor_remote_datasource.dart';
import 'package:zungofee_mobile/features/proveedores/data/models/proveedor.dart';
import 'package:zungofee_mobile/features/proveedores/data/repositories/proveedor_repository.dart';
import 'package:zungofee_mobile/features/proveedores/presentation/providers/proveedor_providers.dart';
import 'package:zungofee_mobile/features/proveedores/presentation/screens/proveedor_form_screen.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

class _FakeProveedorRepository extends ProveedorRepository {
  _FakeProveedorRepository({this.crearError, this.actualizarError})
    : super(ProveedorRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  final Object? crearError;
  final Object? actualizarError;

  int crearCallCount = 0;
  int actualizarCallCount = 0;
  Map<String, dynamic>? ultimoCrear;
  Map<String, dynamic>? ultimoActualizar;

  static const _proveedorGuardado = Proveedor(
    id: 99,
    tenantId: 5,
    nombre: 'Nombre Guardado',
    estado: true,
  );

  @override
  Future<Proveedor> crear({
    required String nombre,
    String? sexo,
    String? lugar,
    String? finca,
    String? telefono,
  }) async {
    crearCallCount++;
    ultimoCrear = {
      'nombre': nombre,
      'sexo': sexo,
      'lugar': lugar,
      'finca': finca,
      'telefono': telefono,
    };
    if (crearError != null) throw crearError!;
    return _proveedorGuardado;
  }

  @override
  Future<Proveedor> actualizar(
    int id, {
    String? nombre,
    String? sexo,
    String? lugar,
    String? finca,
    String? telefono,
  }) async {
    actualizarCallCount++;
    ultimoActualizar = {
      'id': id,
      'nombre': nombre,
      'sexo': sexo,
      'lugar': lugar,
      'finca': finca,
      'telefono': telefono,
    };
    if (actualizarError != null) throw actualizarError!;
    return _proveedorGuardado;
  }

  @override
  Future<List<Proveedor>> getProveedores() async => [];
}

const _proveedorExistente = Proveedor(
  id: 12,
  tenantId: 5,
  nombre: 'Don Chepe Martinez',
  sexo: 'M',
  lugar: 'Marcala',
  finca: 'Finca El Roble',
  telefono: '9999-9999',
  estado: true,
);

Widget _wrap(
  ProveedorRepository repository, {
  Proveedor? proveedorExistente,
  VoidCallback? onGuardado,
}) {
  return ProviderScope(
    overrides: [proveedorRepositoryProvider.overrideWithValue(repository)],
    child: MaterialApp(
      theme: AppTheme.light,
      home: ProveedorFormScreen(
        proveedorExistente: proveedorExistente,
        onGuardado: onGuardado ?? () {},
      ),
    ),
  );
}

void main() {
  group('ProveedorFormScreen', () {
    testWidgets('modo crear: no envía el submit si el nombre está vacío', (
      tester,
    ) async {
      final repository = _FakeProveedorRepository();

      await tester.pumpWidget(_wrap(repository));

      await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
      await tester.pumpAndSettle();

      expect(repository.crearCallCount, 0);
      expect(find.text('Ingresa el nombre'), findsOneWidget);
    });

    testWidgets(
      'modo crear: éxito llama crear() con los valores ingresados y llama '
      'onGuardado',
      (tester) async {
        final repository = _FakeProveedorRepository();
        var guardadoCallCount = 0;

        await tester.pumpWidget(
          _wrap(repository, onGuardado: () => guardadoCallCount++),
        );

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nombre'),
          'Don Chepe Martinez',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, 'Lugar'),
          'Marcala',
        );
        await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
        await tester.pumpAndSettle();

        expect(repository.crearCallCount, 1);
        expect(repository.ultimoCrear?['nombre'], 'Don Chepe Martinez');
        expect(repository.ultimoCrear?['lugar'], 'Marcala');
        expect(repository.ultimoCrear?['finca'], isNull);
        expect(guardadoCallCount, 1);
      },
    );

    testWidgets('modo editar: los campos llegan prellenados', (tester) async {
      final repository = _FakeProveedorRepository();

      await tester.pumpWidget(
        _wrap(repository, proveedorExistente: _proveedorExistente),
      );

      expect(find.text('Don Chepe Martinez'), findsOneWidget);
      expect(find.text('Marcala'), findsOneWidget);
      expect(find.text('Finca El Roble'), findsOneWidget);
      expect(find.text('9999-9999'), findsOneWidget);
      expect(find.widgetWithText(AppBar, 'Editar proveedor'), findsOneWidget);
    });

    testWidgets(
      'modo editar: éxito llama actualizar(id, ...) y llama onGuardado',
      (tester) async {
        final repository = _FakeProveedorRepository();
        var guardadoCallCount = 0;

        await tester.pumpWidget(
          _wrap(
            repository,
            proveedorExistente: _proveedorExistente,
            onGuardado: () => guardadoCallCount++,
          ),
        );

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nombre'),
          'Nombre Editado',
        );
        await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
        await tester.pumpAndSettle();

        expect(repository.actualizarCallCount, 1);
        expect(repository.ultimoActualizar?['id'], 12);
        expect(repository.ultimoActualizar?['nombre'], 'Nombre Editado');
        expect(guardadoCallCount, 1);
      },
    );

    testWidgets('un error de la API se muestra inline y no llama onGuardado', (
      tester,
    ) async {
      final repository = _FakeProveedorRepository(
        crearError: const ApiException(
          statusCode: 400,
          message: 'El nombre ya está registrado',
        ),
      );
      var guardadoCallCount = 0;

      await tester.pumpWidget(
        _wrap(repository, onGuardado: () => guardadoCallCount++),
      );

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Nombre'),
        'Don Chepe Martinez',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
      await tester.pumpAndSettle();

      expect(find.text('El nombre ya está registrado'), findsOneWidget);
      expect(guardadoCallCount, 0);
    });

    testWidgets(
      'modo editar: un error de la API se muestra inline y no llama '
      'onGuardado',
      (tester) async {
        final repository = _FakeProveedorRepository(
          actualizarError: const ApiException(
            statusCode: 403,
            message: 'Forbidden resource',
          ),
        );
        var guardadoCallCount = 0;

        await tester.pumpWidget(
          _wrap(
            repository,
            proveedorExistente: _proveedorExistente,
            onGuardado: () => guardadoCallCount++,
          ),
        );

        await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
        await tester.pumpAndSettle();

        expect(find.text('Forbidden resource'), findsOneWidget);
        expect(guardadoCallCount, 0);
      },
    );

    testWidgets(
      'reabrir el formulario (push/pop reales) tras un error no debe '
      'arrastrar el mensaje del intento anterior',
      (tester) async {
        // Regresión: `proveedorFormControllerProvider` es `autoDispose`
        // precisamente para esto. Este test empuja el formulario a un
        // `Navigator` real, provoca un error, vuelve atrás (disponiendo la
        // pantalla) y lo vuelve a empujar — el flujo real que tendrá Task
        // 6 (`context.push`/`context.pop`), a diferencia de reemplazar el
        // árbol de golpe en el mismo frame.
        final repository = _FakeProveedorRepository(
          crearError: const ApiException(
            statusCode: 400,
            message: 'El nombre ya está registrado',
          ),
        );

        await tester.pumpWidget(
          ProviderScope(
            overrides: [
              proveedorRepositoryProvider.overrideWithValue(repository),
            ],
            child: MaterialApp(
              theme: AppTheme.light,
              home: Builder(
                builder: (context) => Scaffold(
                  body: Center(
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              const ProveedorFormScreen(onGuardado: _noop),
                        ),
                      ),
                      child: const Text('Abrir formulario'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Abrir formulario'));
        await tester.pumpAndSettle();

        await tester.enterText(
          find.widgetWithText(TextFormField, 'Nombre'),
          'Don Chepe Martinez',
        );
        await tester.tap(find.widgetWithText(FilledButton, 'Guardar'));
        await tester.pumpAndSettle();

        expect(find.text('El nombre ya está registrado'), findsOneWidget);

        await tester.pageBack();
        await tester.pumpAndSettle();

        await tester.tap(find.text('Abrir formulario'));
        await tester.pumpAndSettle();

        expect(find.text('El nombre ya está registrado'), findsNothing);
      },
    );
  });
}

void _noop() {}
