import 'package:flutter/material.dart';

/// Pantalla temporal para verificar que [AppRouter] navega correctamente.
///
/// Debe ser reemplazada por la pantalla real (feature de auth/dashboard)
/// en una tarea futura. No debe crecer con logica de negocio.
class SplashPlaceholderScreen extends StatelessWidget {
  const SplashPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Splash placeholder')),
    );
  }
}
