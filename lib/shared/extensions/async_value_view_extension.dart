import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/empty_states/error_retry_view.dart';
import 'error_message_extension.dart';

/// Azúcar sintáctica sobre `AsyncValue.when` para los formularios que
/// dependen de varios recursos async de solo lectura (`CompraFormScreen`,
/// `VentaFormScreen`, `ProcesamientoFormScreen`): reemplaza el bloque de
/// `loading`/`error` — antes repetido literalmente por cada recurso — por
/// una sola llamada, reutilizando [ErrorRetryView] y [ErrorMessageX].
extension AsyncValueViewX<T> on AsyncValue<T> {
  Widget buildOrRetry({
    required Widget Function(T data) data,
    required VoidCallback onRetry,
    required String errorFallback,
  }) {
    return when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => ErrorRetryView(
        message: error.errorMessage(fallback: errorFallback),
        onRetry: onRetry,
      ),
      data: data,
    );
  }
}
