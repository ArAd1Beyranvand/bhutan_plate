import 'package:plate_core/plate_core.dart';

import 'bhutan_colors.dart';

/// Bhutan as a `PlateCountry`. The plates carry no country block (the
/// Dzongkha caption is a label on the face), so every spec sets `noPanel`.
abstract final class BhutanCountry {
  static const PlateCountry bhutan = PlateCountry(
    code: 'bt',
    captionLines: <String>[],
    panelColor: BhutanColors.red,
    panelTextColor: BhutanColors.white,
  );
}
