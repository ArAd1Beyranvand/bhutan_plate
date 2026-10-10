import 'package:flutter/widgets.dart';

/// The colours of the Bhutanese plates, sampled from the flattened,
/// colour-balanced reference photographs (the Royal Guard plate from its
/// uncorrected original, so it is dimmer).
abstract final class BhutanColors {
  /// Private field: `DD4A3C`.
  static const Color red = Color(0xFFDD4A3C);

  /// Private ink: `EEECEC`.
  static const Color white = Color(0xFFEEECEC);

  /// Government field: `EF5652`, a lighter red than the private plate in its
  /// photograph; it is the sampled value, kept as measured.
  static const Color governmentRed = Color(0xFFEF5652);

  /// Government ink: `FAB83E`.
  static const Color governmentYellow = Color(0xFFFAB83E);

  /// Taxi field: `E9C914`.
  static const Color taxiYellow = Color(0xFFE9C914);

  /// Taxi ink and frame: `383A3B`.
  static const Color taxiBlack = Color(0xFF383A3B);

  /// Police field: `154492`.
  static const Color policeBlue = Color(0xFF154492);

  /// Police ink: `9F9B7A`, a faded cream in the photograph.
  static const Color policeInk = Color(0xFF9F9B7A);

  /// Diplomatic field: `024CC3`.
  static const Color diplomaticBlue = Color(0xFF024CC3);

  /// Royal Guard left half: `24281C`.
  static const Color guardGreen = Color(0xFF24281C);

  /// Royal Guard diagonal, upper half: `D4A438`.
  static const Color guardYellow = Color(0xFFD4A438);

  /// Royal Guard diagonal, lower half: `981C20`.
  static const Color guardRed = Color(0xFF981C20);

  /// Royal Guard ink: `D4CCC0`.
  static const Color guardWhite = Color(0xFFD4CCC0);

  static const Color inactive = Color(0xFFB0B0B0);
}
