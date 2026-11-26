import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Reusable AppLogo widget rendering the official BlogHub "B." SVG monogram.
class AppLogo extends StatelessWidget {
  /// The size (width and height) of the logo.
  final double size;

  /// How to inscribe the logo into the space allocated during layout.
  final BoxFit fit;

  const AppLogo({
    super.key,
    this.size = 48.0,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/logo/logo.svg',
      width: size,
      height: size,
      fit: fit,
      semanticsLabel: 'BlogHub Authors Logo',
    );
  }
}

