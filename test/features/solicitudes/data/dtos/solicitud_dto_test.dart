import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/features/solicitudes/data/dtos/solicitud_dto.dart';

void main() {
  group('SolicitudDto', () {
    // JSON de ejemplo de `GET /solicitudes` (contrato confirmado por
    // Rubio, backend).
    final json = {
      'id': 3,
      'nombre_bodega': 'Bodega Mertens',
      'nombre_contacto': 'Martin Mertens',
      'email': 'mertens@gmail.com',
      'telefono': '+504 99887766',
      'mensaje': '3 empleados.',
      'estado_id': 2,
      'tenant_creado_id': 21,
      'fecha_creacion': '2026-07-24T05:16:35.020Z',
    };

    test('fromJson parsea todos los campos del DTO', () {
      final dto = SolicitudDto.fromJson(json);

      expect(dto.id, 3);
      expect(dto.nombreBodega, 'Bodega Mertens');
      expect(dto.nombreContacto, 'Martin Mertens');
      expect(dto.email, 'mertens@gmail.com');
      expect(dto.telefono, '+504 99887766');
      expect(dto.mensaje, '3 empleados.');
      expect(dto.estadoId, 2);
      expect(dto.tenantCreadoId, 21);
      expect(dto.fechaCreacion, '2026-07-24T05:16:35.020Z');
    });

    test('toDomain mapea al modelo de dominio Solicitud', () {
      final solicitud = SolicitudDto.fromJson(json).toDomain();

      expect(solicitud.id, 3);
      expect(solicitud.nombreBodega, 'Bodega Mertens');
      expect(solicitud.estadoId, 2);
      expect(solicitud.pendiente, isFalse);
      expect(solicitud.estadoLabel, 'Procesada');
      expect(solicitud.tenantCreadoId, 21);
      expect(
        solicitud.fechaCreacion,
        DateTime.parse('2026-07-24T05:16:35.020Z'),
      );
    });

    test(
      'solicitud pendiente: mensaje y tenant_creado_id nulos no rompen '
      'el parseo',
      () {
        final jsonPendiente = {
          'id': 43,
          'nombre_bodega': 'Bodega Nueva',
          'nombre_contacto': 'Ana Torres',
          'email': 'ana@bodeganueva.com',
          'telefono': '+504 88776655',
          'mensaje': null,
          'estado_id': 1,
          'tenant_creado_id': null,
          'fecha_creacion': '2026-07-25T00:00:00.000Z',
        };

        final solicitud = SolicitudDto.fromJson(jsonPendiente).toDomain();

        expect(solicitud.mensaje, isNull);
        expect(solicitud.tenantCreadoId, isNull);
        expect(solicitud.pendiente, isTrue);
        expect(solicitud.estadoLabel, 'Pendiente');
      },
    );

    test(
      'telefono nulo (dato real de producción) no rompe el parseo',
      () {
        final jsonSinTelefono = {
          'id': 5,
          'nombre_bodega': 'Bodega Ejemplo',
          'nombre_contacto': 'Zunga Mayor',
          'email': 'zungamayor@gmail.com',
          'telefono': null,
          'mensaje': 'Ayudenme a hacer mi perfil.',
          'estado_id': 2,
          'tenant_creado_id': 30,
          'fecha_creacion': '2026-07-23T00:00:00.000Z',
        };

        final solicitud = SolicitudDto.fromJson(jsonSinTelefono).toDomain();

        expect(solicitud.telefono, isNull);
        expect(solicitud.nombreBodega, 'Bodega Ejemplo');
      },
    );

    test('estado_id 3 mapea a estadoLabel "Rechazada"', () {
      final solicitud = SolicitudDto.fromJson({
        ...json,
        'estado_id': 3,
      }).toDomain();

      expect(solicitud.estadoLabel, 'Rechazada');
      expect(solicitud.pendiente, isFalse);
    });
  });
}
