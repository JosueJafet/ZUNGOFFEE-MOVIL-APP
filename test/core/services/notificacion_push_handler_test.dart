import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/api/api_client.dart';
import 'package:zungofee_mobile/core/api/session_token_provider.dart';
import 'package:zungofee_mobile/core/services/local_notifications_service.dart';
import 'package:zungofee_mobile/core/services/notificacion_push_handler.dart';
import 'package:zungofee_mobile/features/notificaciones/data/datasources/notificaciones_remote_datasource.dart';
import 'package:zungofee_mobile/features/notificaciones/data/models/notificacion.dart';
import 'package:zungofee_mobile/features/notificaciones/data/repositories/notificaciones_repository.dart';
import 'package:zungofee_mobile/features/notificaciones/presentation/providers/notificaciones_providers.dart';

class _FakeSessionTokenProvider implements SessionTokenProvider {
  @override
  String? get accessToken => null;
}

const _notificacion = Notificacion(
  id: '1',
  titulo: 'Nueva venta',
  mensaje: 'L. 500',
  leida: false,
);

class _FakeNotificacionesRepository extends NotificacionesRepository {
  _FakeNotificacionesRepository()
    : super(NotificacionesRemoteDataSource(ApiClient(_FakeSessionTokenProvider())));

  int listarCallCount = 0;
  String? ultimoIdMarcadoLeido;

  @override
  Future<List<Notificacion>> listar({int page = 1, int pageSize = 50}) async {
    listarCallCount++;
    return const [_notificacion];
  }

  @override
  Future<void> marcarLeida(String id) async {
    ultimoIdMarcadoLeido = id;
  }
}

class _FakeLocalNotificationsService implements LocalNotificationsService {
  int mostrarCallCount = 0;
  String? ultimoTitulo;
  String? ultimoCuerpo;
  String? ultimoPayload;

  @override
  Future<void> inicializar({required void Function(String? payload) onTap}) async {}

  @override
  Future<void> mostrar({String? titulo, String? cuerpo, String? payload}) async {
    mostrarCallCount++;
    ultimoTitulo = titulo;
    ultimoCuerpo = cuerpo;
    ultimoPayload = payload;
  }
}

void main() {
  group('NotificacionPushHandler', () {
    late _FakeNotificacionesRepository repository;
    late _FakeLocalNotificationsService localNotificationsService;
    late ProviderContainer container;
    late List<String> rutasNavegadas;
    late NotificacionPushHandler handler;

    setUp(() {
      repository = _FakeNotificacionesRepository();
      localNotificationsService = _FakeLocalNotificationsService();
      container = ProviderContainer(
        overrides: [notificacionesRepositoryProvider.overrideWithValue(repository)],
      );
      rutasNavegadas = [];
      handler = NotificacionPushHandler(
        onNavegar: rutasNavegadas.add,
        container: container,
        localNotificationsService: localNotificationsService,
      );
    });

    tearDown(() => container.dispose());

    test('manejarTap navega a la ruta correcta según data.tipo', () {
      handler.manejarTap({'tipo': 'compra_registrada'});

      expect(rutasNavegadas, ['/compras/historial']);
    });

    test('manejarTap con un tipo desconocido no navega', () {
      handler.manejarTap({'tipo': 'algo_nuevo_no_contemplado'});

      expect(rutasNavegadas, isEmpty);
    });

    test(
      'manejarTap con notificacionId marca la notificación como leída',
      () async {
        handler.manejarTap({
          'tipo': 'venta_registrada',
          'notificacionId': '482',
        });
        await Future<void>.delayed(Duration.zero);

        expect(repository.ultimoIdMarcadoLeido, '482');
      },
    );

    test('manejarTap sin notificacionId no llama marcarLeida', () async {
      handler.manejarTap({'tipo': 'venta_registrada'});
      await Future<void>.delayed(Duration.zero);

      expect(repository.ultimoIdMarcadoLeido, isNull);
    });

    test(
      'manejarMensajeEnPrimerPlano invalida notificacionesProvider y '
      'muestra la notificación local con título/cuerpo/payload',
      () async {
        await container.read(notificacionesProvider.future);
        expect(repository.listarCallCount, 1);

        const message = RemoteMessage(
          notification: RemoteNotification(title: 'Nueva venta', body: 'L. 500'),
          data: {'tipo': 'venta_registrada', 'referenciaId': '10'},
        );

        await handler.manejarMensajeEnPrimerPlano(message);

        // Si no hubiera invalidado, este segundo `read` devolvería el
        // valor cacheado sin volver a llamar `listar`.
        await container.read(notificacionesProvider.future);
        expect(repository.listarCallCount, 2);

        expect(localNotificationsService.mostrarCallCount, 1);
        expect(localNotificationsService.ultimoTitulo, 'Nueva venta');
        expect(localNotificationsService.ultimoCuerpo, 'L. 500');
        expect(
          localNotificationsService.ultimoPayload,
          jsonEncode({'tipo': 'venta_registrada', 'referenciaId': '10'}),
        );
      },
    );
  });
}
