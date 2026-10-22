import 'package:bhutan_plate/bhutan_plate.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plate_core/plate_core.dart';

void main() {
  test('the area digit names its districts', () {
    expect(BhutanRegions.lookup('1'), contains('Thimphu'));
    expect(BhutanRegions.lookup('2'), 'Chukha, Samtse');
    expect(BhutanRegions.lookup('5'), contains('Mongar'));
  });

  test('nothing for an empty or unused digit', () {
    for (final String d in <String>['', '0', '6', '9']) {
      expect(BhutanRegions.lookup(d), isNull, reason: d);
    }
  });

  test('only the plates with an area digit resolve it', () {
    for (final PlateSpec spec in BhutanPlates.all) {
      final bool hasArea = spec.effectiveTextGroups.any((PlateTextGroup g) => g.key == 'area');
      expect(spec.resolveRegion != null, hasArea, reason: spec.id);
    }
  });

  test('the controller follows the area digit typed and deleted', () {
    final PlateController c = PlateController(spec: BhutanPlates.private);
    c.setGroup('type', 'BP');
    expect(c.regionCaption, isNull);
    c.setGroup('area', '2');
    expect(c.regionCaption, 'Chukha, Samtse');
    c.setGroup('area', '');
    expect(c.regionCaption, isNull);
  });
}
