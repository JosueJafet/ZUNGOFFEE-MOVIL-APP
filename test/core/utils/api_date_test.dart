import 'package:flutter_test/flutter_test.dart';
import 'package:zungofee_mobile/core/utils/api_date.dart';

void main() {
  group('ApiDate', () {
    test('toRequestDate formatea como YYYY-MM-DD', () {
      expect(ApiDate.toRequestDate(DateTime(2026, 8, 1)), '2026-08-01');
    });

    test('fromResponse parsea un datetime ISO completo', () {
      final parsed = ApiDate.fromResponse('2026-08-01T00:00:00.000Z');
      expect(parsed, DateTime.utc(2026, 8, 1));
    });
  });
}
