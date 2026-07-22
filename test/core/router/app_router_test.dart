import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zungofee_mobile/core/router/app_router.dart';
import 'package:zungofee_mobile/core/router/route_paths.dart';

void main() {
  testWidgets('AppRouter shows splash and navigates to home', (tester) async {
    final router = AppRouter.router;
    addTearDown(() => router.go(RoutePaths.splash));

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    expect(find.text('Splash placeholder'), findsOneWidget);

    router.go(RoutePaths.home);
    await tester.pumpAndSettle();

    expect(find.text('Home placeholder'), findsOneWidget);
  });
}
