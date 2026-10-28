import 'package:plate_core/plate_core.dart';

/// Locates a Bhutanese plate from its area digit (the `1` of `BP-1-A1234`).
///
/// The digit names a group of districts, not one: a plate in area 1 may be
/// registered in any of six.
///
/// Source: https://en.wikipedia.org/wiki/Vehicle_registration_plates_of_Bhutan
abstract final class BhutanRegions {
  static const Map<String, String> _areas = <String, String>{
    '1': 'Gasa, Haa, Paro, Punakha, Thimphu, Wangdue Phodrang',
    '2': 'Chukha, Samtse',
    '3': 'Bumthang, Dagana, Sarpang, Trongsa, Tsirang, Zhemgang',
    '4': 'Pemagatshel, Samdrup Jongkhar',
    '5': 'Lhuntse, Mongar, Trashigang, Trashiyangtse',
  };

  /// The districts of area [digit], or null while empty or not 1 to 5.
  static String? lookup(String digit) => _areas[digit];

  /// A [PlateLabelResolver] for [PlateSpec.resolveRegion].
  static String? captionOf(String Function(String key) group) =>
      lookup(group('area'));
}
