import 'package:plate_core/plate_core.dart';

/// Judges a Bhutanese plate. Reports, never bars a keystroke.
///
/// Every category keeps its type letters in the `type` group and its serial in
/// `number`; the civil plates (`BP-1-A1234`) also have `area` (1 to 5) and
/// `series` (a letter). [types] are the type codes the category carries.
class BhutanValidator extends GatedPlateValidator {
  const BhutanValidator({this.types = const <String>['BP', 'BT', 'BG']});

  /// Royal Bhutan Police: `RBP-2300`.
  const BhutanValidator.police() : types = const <String>['RBP'];

  /// Royal Bodyguard: `RBG 8047`.
  const BhutanValidator.royalGuard() : types = const <String>['RBG'];

  final List<String> types;

  static final RegExp _area = RegExp(r'^[1-5]$');
  static final RegExp _series = RegExp(r'^[A-Z]$');

  @override
  String get gateGroup => 'type';

  @override
  PlateValidation judge(PlateEntry entry) {
    final String type = entry.group('type');
    if (!types.contains(type)) {
      return PlateValidation.invalid('The type is ${types.join(' or ')}.');
    }
    final keys = {for (final g in entry.spec.effectiveTextGroups) g.key};
    if (keys.contains('area') && !_area.hasMatch(entry.group('area'))) {
      return PlateValidation.invalid('The area code is 1 to 5.');
    }
    if (keys.contains('series') && !_series.hasMatch(entry.group('series'))) {
      return PlateValidation.invalid('The series is one letter.');
    }
    if (!isDigitsOfLength(entry.group('number'), 4)) {
      return PlateValidation.invalid('The number is 4 digits.');
    }
    return const PlateValidation.valid();
  }
}

/// Judges a diplomatic plate: a country or organisation number (1 or 2
/// digits), "CD" and a serial (1 or 2 digits).
class BhutanDiplomaticValidator extends GatedPlateValidator {
  const BhutanDiplomaticValidator();

  static final RegExp _digits = RegExp(r'^[0-9]{1,2}$');

  @override
  String get gateGroup => 'country';

  @override
  PlateValidation judge(PlateEntry entry) {
    if (!_digits.hasMatch(entry.group('country'))) {
      return PlateValidation.invalid('The country number is 1 or 2 digits.');
    }
    if (!_digits.hasMatch(entry.group('serial'))) {
      return PlateValidation.invalid('The serial is 1 or 2 digits.');
    }
    return const PlateValidation.valid();
  }
}
