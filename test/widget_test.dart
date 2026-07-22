import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/main.dart';

void main() {
  testWidgets('ZungofeeApp builds without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: ZungofeeApp()));

    expect(find.byType(ZungofeeApp), findsOneWidget);
  });
}
