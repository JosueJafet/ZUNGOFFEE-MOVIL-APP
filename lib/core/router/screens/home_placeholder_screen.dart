import 'package:flutter/material.dart';

/// Pantalla temporal para verificar que [AppRouter] navega correctamente.
///
/// Debe ser reemplazada por la pantalla real (feature de dashboard) en
/// una tarea futura. No debe crecer con logica de negocio.
class HomePlaceholderScreen extends StatelessWidget {
  const HomePlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Home placeholder')),
    );
  }
}
