import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Isotipo oficial de Zungoffee — pieza de marca separada de
/// [ZungoffeeWordmark] (el texto "Zungoffee"): una es el símbolo
/// gráfico, la otra el nombre en tipografía. Se usan juntas en pantallas
/// como `LoginScreen`, pero cada una vive en su propio widget.
class ZungoffeeLogo extends StatelessWidget {
  const ZungoffeeLogo({super.key, this.size = 96});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/brand/zungoffee_logo.svg',
      width: size,
      height: size,
    );
  }
}
