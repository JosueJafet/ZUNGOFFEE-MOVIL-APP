import 'package:flutter/material.dart';

/// Pantalla temporal: destino del redirect cuando no hay sesión activa.
///
/// Debe ser reemplazada por la pantalla real de login (`features/auth`)
/// en un sprint posterior; no debe crecer con formularios ni lógica.
class LoginPlaceholderScreen extends StatelessWidget {
  const LoginPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Login placeholder')),
    );
  }
}
