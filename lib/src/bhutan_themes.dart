import 'package:flutter/widgets.dart';
import 'package:plate_core/plate_core.dart';

import 'bhutan_colors.dart';

/// One ink on one field. Only the taxi plate has a frame (black, measured
/// ~0.03 of the height); the others are printed to the edge.
abstract final class BhutanThemes {
  static final PlateTheme private = _ink(BhutanColors.red, BhutanColors.white);

  static final PlateTheme government = _ink(
    BhutanColors.governmentRed,
    BhutanColors.governmentYellow,
  );

  static final PlateTheme taxi = _ink(BhutanColors.taxiYellow, BhutanColors.taxiBlack, frame: 0.03);

  static final PlateTheme police = _ink(BhutanColors.policeBlue, BhutanColors.policeInk);

  static final PlateTheme diplomatic = _ink(BhutanColors.diplomaticBlue, BhutanColors.white);

  /// The field is the green left half; the diagonal half is painted by the
  /// spec's background.
  static final PlateTheme royalGuard = _ink(BhutanColors.guardGreen, BhutanColors.guardWhite);
}

PlateTheme _ink(Color field, Color ink, {double frame = 0}) => PlateTheme.monochrome(
  field: field,
  ink: ink,
  inactive: BhutanColors.inactive,
  borderWidthRatio: frame,
  plateRadiusRatio: 0.05,
);
