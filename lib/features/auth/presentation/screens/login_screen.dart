import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/extensions/error_message_extension.dart';
import '../../../../shared/widgets/brand/zungoffee_logo.dart';
import '../../../../shared/widgets/brand/zungoffee_wordmark.dart';
import '../../../../shared/widgets/interactions/hover_scale.dart';
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

  bool _obscurePassword = true;

  // Fade-in único al montar la pantalla — sin `AnimationController`
  // adicional, ya que es una sola transición de entrada.
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _visible = true);
    });
  }

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

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginControllerProvider);
    final isLoading = loginState.isLoading;
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Stack(
        children: [
          // Detalle de fondo muy sutil — dos círculos difuminados de
          // opacidad mínima, puramente decorativos.
          Positioned(
            top: -90,
            left: -90,
            child: _GlowCircle(color: primary, size: 260),
          ),
          Positioned(
            bottom: -110,
            right: -110,
            child: _GlowCircle(color: primary, size: 320),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.space6),
                child: AnimatedOpacity(
                  opacity: _visible ? 1 : 0,
                  duration: const Duration(milliseconds: 400),
                  child: HoverScale(
                    scale: 1.01,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 460),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.space6),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Center(child: ZungoffeeLogo(size: 96)),
                                const SizedBox(height: AppSpacing.space4),
                                const Center(child: ZungoffeeWordmark()),
                                const SizedBox(height: AppSpacing.space4),
                                Text(
                                  'Bienvenido nuevamente',
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: AppSpacing.space2),
                                Text(
                                  'Inicia sesión para continuar',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: AppSpacing.space6),
                                AutofillGroup(
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        autofillHints: const [AutofillHints.email],
                                        decoration: const InputDecoration(
                                          labelText: 'Correo',
                                          prefixIcon: Icon(Icons.mail_outline),
                                        ),
                                        validator: _validateEmail,
                                        enabled: !isLoading,
                                      ),
                                      const SizedBox(height: AppSpacing.space4),
                                      TextFormField(
                                        controller: _passwordController,
                                        obscureText: _obscurePassword,
                                        autofillHints: const [
                                          AutofillHints.password,
                                        ],
                                        decoration: InputDecoration(
                                          labelText: 'Contraseña',
                                          prefixIcon: const Icon(
                                            Icons.lock_outline,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscurePassword
                                                  ? Icons.visibility_outlined
                                                  : Icons
                                                        .visibility_off_outlined,
                                            ),
                                            tooltip: _obscurePassword
                                                ? 'Mostrar contraseña'
                                                : 'Ocultar contraseña',
                                            onPressed: () => setState(
                                              () => _obscurePassword =
                                                  !_obscurePassword,
                                            ),
                                          ),
                                        ),
                                        validator: _validatePassword,
                                        enabled: !isLoading,
                                        onFieldSubmitted: (_) => _submit(),
                                      ),
                                    ],
                                  ),
                                ),
                                if (loginState.hasError) ...[
                                  const SizedBox(height: AppSpacing.space4),
                                  Text(
                                    loginState.error!.errorMessage(
                                      fallback:
                                          'No se pudo iniciar sesión. Intenta '
                                          'de nuevo.',
                                    ),
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.error,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                                const SizedBox(height: AppSpacing.space6),
                                HoverScale(
                                  child: FilledButton(
                                    style: FilledButton.styleFrom(
                                      minimumSize: const Size.fromHeight(52),
                                      elevation: 2,
                                    ),
                                    onPressed: isLoading ? null : _submit,
                                    child: isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Text('Iniciar sesión'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Círculo difuminado de opacidad mínima usado como detalle de fondo —
/// puramente decorativo, sin interacción.
class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.05),
        ),
      ),
    );
  }
}
