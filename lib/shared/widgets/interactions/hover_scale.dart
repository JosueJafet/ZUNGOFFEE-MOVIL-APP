import 'package:flutter/material.dart';

/// Envuelve [child] con una leve animación de escala al pasar el mouse
/// por encima (Flutter Web/desktop) — en touch, sin mouse, [MouseRegion]
/// simplemente nunca dispara `onEnter`/`onExit`, así que no hace nada.
///
/// Reutilizado por el botón/Card de `LoginScreen` para no duplicar la
/// misma lógica de hover en más de un lugar.
class HoverScale extends StatefulWidget {
  const HoverScale({
    super.key,
    required this.child,
    this.scale = 1.03,
    this.duration = const Duration(milliseconds: 150),
  });

  final Widget child;
  final double scale;
  final Duration duration;

  @override
  State<HoverScale> createState() => _HoverScaleState();
}

class _HoverScaleState extends State<HoverScale> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? widget.scale : 1.0,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
