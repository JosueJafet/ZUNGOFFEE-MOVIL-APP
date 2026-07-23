import 'package:flutter_test/flutter_test.dart';
import 'package:zungofee_mobile/core/utils/bigint_id.dart';

void main() {
  group('BigIntId.fromJson', () {
    test('lee un String tal cual', () {
      expect(BigIntId.fromJson('78'), '78');
    });

    test('acepta un num por robustez y lo normaliza a String', () {
      expect(BigIntId.fromJson(78), '78');
    });

    test('lanza FormatException para un tipo inesperado', () {
      expect(() => BigIntId.fromJson(null), throwsFormatException);
    });
  });

  group('BigIntId.toBigInt', () {
    test('convierte el String a BigInt', () {
      expect(BigIntId.toBigInt('78'), BigInt.from(78));
    });
  });
}
