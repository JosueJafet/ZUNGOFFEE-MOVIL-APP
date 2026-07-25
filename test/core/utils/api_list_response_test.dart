import 'package:flutter_test/flutter_test.dart';
import 'package:zungofee_mobile/core/utils/api_list_response.dart';

void main() {
  group('ApiListResponse.extractItems', () {
    test('usa la lista tal cual cuando la respuesta ya es un array', () {
      final items = ApiListResponse.extractItems([
        {'id': 1},
        {'id': 2},
      ]);

      expect(items, hasLength(2));
    });

    test(
      'encuentra la lista dentro de un Map sin depender del nombre de la clave',
      () {
        final items = ApiListResponse.extractItems({
          'meta': {'page': 1},
          'algunaClaveInesperada': [
            {'id': 1},
          ],
        });

        expect(items, hasLength(1));
      },
    );

    test('lanza FormatException si no encuentra ninguna lista', () {
      expect(
        () => ApiListResponse.extractItems({'id': 1}),
        throwsFormatException,
      );
    });

    test('lanza FormatException para un tipo inesperado (null, String)', () {
      expect(() => ApiListResponse.extractItems(null), throwsFormatException);
      expect(
        () => ApiListResponse.extractItems('no es una lista'),
        throwsFormatException,
      );
    });
  });
}
