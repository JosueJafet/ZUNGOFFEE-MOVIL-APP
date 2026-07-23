import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/api_exception.dart';
import '../../../../core/errors/network_exception.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/login_controller.dart';

/// Pantalla de login real. Solo invoca `signIn` y muestra loading/error —
/// nunca navega ni importa nada de `core/router/`. La redirección a
/// `home` ocurre sola, como efecto del cambio de sesión que ya observa
/// `AppRouter` (ver nota de arquitectura del Sprint 3).
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Ingresa tu correo';
    if (!email.contains('@') || !email.contains('.')) {
      return 'Ingresa un correo válido';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Ingresa tu contraseña';
    return null;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    await ref
        .read(loginControllerProvider.notifier)
        .signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  String _errorMessage(Object error) {
    if (error is ApiException) {
      return error.message ?? 'No se pudo iniciar sesión. Intenta de nuevo.';
    }
    if (error is NetworkException) {
      return error.message;
    }
    return 'No se pudo iniciar sesión. Intenta de nuevo.';
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);
    final isLoading = loginState.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.space6),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Iniciar sesión',
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.space6),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    decoration: const InputDecoration(labelText: 'Correo'),
                    validator: _validateEmail,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: AppSpacing.space4),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    autofillHints: const [AutofillHints.password],
                    decoration: const InputDecoration(labelText: 'Contraseña'),
                    validator: _validatePassword,
                    enabled: !isLoading,
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  if (loginState.hasError) ...[
                    const SizedBox(height: AppSpacing.space4),
                    Text(
                      _errorMessage(loginState.error!),
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.space6),
                  FilledButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Entrar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
