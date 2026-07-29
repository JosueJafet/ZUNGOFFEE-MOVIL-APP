import 'package:flutter/material.dart';

/// Confirmación visible de que una acción terminó con éxito — hoy usado
/// por los formularios de "Guardar" (`crear`/`actualizar`), que antes
/// solo hacían `pop`/navegaban sin ningún indicio de que el guardado
/// funcionó.
extension SuccessSnackBarX on BuildContext {
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }
}
