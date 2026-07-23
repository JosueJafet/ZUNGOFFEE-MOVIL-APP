import 'package:flutter_test/flutter_test.dart';
import 'package:zungofee_mobile/core/utils/api_decimal.dart';

void main() {
  group('ApiDecimal.fromJson', () {
    test('parsea un String decimal', () {
      expect(ApiDecimal.fromJson('123.45'), 123.45);
    });

    test('acepta un num por robustez', () {
      expect(ApiDecimal.fromJson(123.45), 123.45);
    });

    test('lanza FormatException para un tipo inesperado', () {
      expect(() => ApiDecimal.fromJson(null), throwsFormatException);
    });
  });
}
