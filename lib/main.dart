import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// NOTA: este archivo es únicamente el punto de entrada de la aplicación.
// No contiene lógica de negocio ni de ningún módulo (feature).
// El router (GoRouter) y el tema se conectarán aquí cuando
// core/router y core/theme sean implementados en una fase posterior.

void main() {
  runApp(const ProviderScope(child: ZungofeeApp()));
}

class ZungofeeApp extends StatelessWidget {
  const ZungofeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Zungofee Mobile',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Text('Zungofee Mobile — estructura inicial'),
        ),
      ),
    );
  }
}
