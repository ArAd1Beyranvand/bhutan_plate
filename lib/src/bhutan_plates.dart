import 'dart:math';

import 'package:plate_alphabet/plate_alphabet.dart';
import 'package:plate_core/plate_core.dart';

import 'bhutan_colors.dart';
import 'bhutan_country.dart';
import 'bhutan_regions.dart';

/// Where the ink sits, in plate units.
///
/// The article's infobox gives 520×110, which none of the photographs
/// agrees with; the photographs fit 2.5–3.0 and were all flattened to
/// 500 × 181.7, so that is the canvas of every civil design. Rows are the
/// ink bands measured on the flattened plates (`sheet_flat.png`):
///
/// | plate      | caption ink y, x-span | number ink y | number x-span |
/// |------------|-----------------------|--------------|---------------|
/// | private    | 13–91, 29.5–413.5     | 92.5–171     | 22.2–499      |
/// | government | 13–108, 107.5–414.5   | 118–175.8    | 20.8–499      |
/// | police     | 14.5–104, 120–389.5   | 108.5–173.2  | 27–495        |
/// | diplomatic | 17.8–106, 102–410     | 114.8–175.8  | 20.8–499      |
/// | taxi       | ~21–77 (sheet scale)  | 95.7–159.6   | ~31–469       |
///
/// The taxi caption and number x-span are read off the downscaled sheet, not
/// measured: its black frame defeats the ink projection.
///
/// The number ink is 58–78 tall on a 182 plate. A glyph's ink is ~55% of its
/// box, and the box may not leave the canvas, so the number row is capped at
/// the room under its centre; the characters land at 55–75% of the reference
/// height (private 98 → ~54 of 78; government 68 → ~37 of 58).
abstract final class _Layout {
  static const double width = 500, height = 181.7;

  static const _Row private = _Row(
    left: 22.2,
    right: 499,
    cy: 131.75,
    box: 98,
    captionCx: 221.5,
    captionCy: 52,
    captionBox: 80,
    captionGlyph: 70,
  );
  static const _Row government = _Row(
    left: 20.8,
    right: 499,
    cy: 147,
    box: 68,
    captionCx: 261,
    captionCy: 60.5,
    captionBox: 95,
    captionGlyph: 80,
  );
  static const _Row taxi = _Row(
    left: 31,
    right: 469,
    cy: 127.6,
    box: 98,
    captionCx: 256,
    captionCy: 49,
    captionBox: 56,
    captionGlyph: 56,
  );
  static const _Row police = _Row(
    left: 27,
    right: 495,
    cy: 140.85,
    box: 80,
    captionCx: 254.75,
    captionCy: 59,
    captionBox: 90,
    captionGlyph: 70,
  );

  /// Diplomatic: six equal cells over x 20.8–499 — the country number (two),
  /// "CD" across the middle two, the serial (two). The reference spaces its
  /// single characters 5 · CD · 8 across the same span.
  static const _Row diplomatic = _Row(
    left: 20.8,
    right: 499,
    cy: 145.3,
    box: 72,
    captionCx: 256,
    captionCy: 62,
    captionBox: 88,
    captionGlyph: 80,
  );

  /// Royal Guard: photographed at 3.54, normalised to 500 × 141 (plate
  /// rectangle 1245 × 352 px in `orig_BHUTAN…woody1778a.jpg`). One row, letters
  /// at pitch 85 (cell centres 54, 139, 224) on the dark half, digits at pitch
  /// 53 (centres 308, 360, 416, 466) on the diagonal half. Ink 86 tall; the
  /// box is capped by the 141 canvas. The halves meet at x = 275, and the
  /// yellow/red boundary runs from (275, 129) to (496, 7): atan(122/221)
  /// rising to the right, crossing the right half's centreline (x 387.5) at
  /// y = 67.
  static const double guardHeight = 141, guardCy = 70, guardBox = 125;
  static const double guardSplit = 275;
  static const double guardLettersLeft = 12, guardLettersPitch = 85;
  static const double guardDigitsLeft = 281.5, guardDigitsPitch = 53;
  static const double guardStop = 67, guardAngle = 0.5;
}

class _Row {
  const _Row({
    required this.left,
    required this.right,
    required this.cy,
    required this.box,
    required this.captionCx,
    required this.captionCy,
    required this.captionBox,
    required this.captionGlyph,
  });

  /// The number row spans [left]–[right]; its glyph box is [box] tall,
  /// centred on [cy].
  final double left, right, cy, box;

  /// The Dzongkha caption, centred on ([captionCx], [captionCy]).
  final double captionCx, captionCy, captionBox, captionGlyph;

  double get top => cy - box / 2;
}

/// A run of slots in the number row: [count] cells of [alphabet] under the
/// text-group [key], followed by a dash when [dash] is set.
class _Part {
  const _Part(this.key, this.alphabet, this.count, {this.dash = false});
  final String key;
  final PlateAlphabet alphabet;
  final int count;
  final bool dash;
}

/// Bhutan's current plates.
///
/// Four designs. The civil one (private, government, taxi, police) is a
/// Dzongkha caption over one row `BP-1-A1234` / `RBP-2300`, equal pitch with
/// the dashes as cells of their own; it differs only in the row's position,
/// the format and the caption, so one builder serves all four. Diplomatic has
/// a different row (`5 CD 8`), the Royal Guard a green half beside a
/// yellow/red diagonal half. Colour is the theme's: pair each with the
/// [BhutanThemes] member of the same name.
///
/// The plates have no printed frame except the taxi's (a theme ratio), so the
/// only painted background is the Royal Guard's, a [PlateSection] with a
/// diagonal stripes fill.
///
/// The Dzongkha captions are not transcribed from the article, which only
/// says "Representative" for the diplomatic one; they follow the shapes on the
/// photographs and are unverified. The Royal Guard plate is the 1970s one the
/// article pictures; the article's prose describes the current one as black,
/// orange and yellow. Not implemented: older numeric-only series.
abstract final class BhutanPlates {
  static PlateSlot _field(
    PlateAlphabet alphabet,
    int count,
    double left,
    double pitch,
    double top,
    double height,
  ) => PlateSlot(
    alphabet: alphabet,
    box: PlateBox(left, top, count * pitch, height),
    length: count,
    spacing: max(0, pitch - 0.6 * 0.72 * height),
  );

  static PlateLabel _caption(_Row row, String text) => PlateLabel(
    text: text,
    box: PlateBox(row.captionCx - 150, row.captionCy - row.captionBox / 2, 300, row.captionBox),
    glyphHeight: row.captionGlyph,
  );

  /// `BP-1-A1234`: white on red.
  static final PlateSpec private = _civil(
    'bt.private',
    _Layout.private,
    'འབྲུག་སྒེར་',
    _civilParts,
  );

  /// `BG-1-A1234`: yellow on red.
  static final PlateSpec government = _civil(
    'bt.government',
    _Layout.government,
    'འབྲུག་གཞུང་',
    _civilParts,
  );

  /// `BT-1-A1234`: black on yellow in a black frame.
  static final PlateSpec taxi = _civil('bt.taxi', _Layout.taxi, 'འབྲུག་གླ་', _civilParts);

  /// `RBP-2300`: light on blue.
  static final PlateSpec police = _civil(
    'bt.police',
    _Layout.police,
    'འབྲུག་ཞི་བདེ་',
    _policeParts,
  );

  /// `5 CD 8`: white on blue, "Representative" above.
  static final PlateSpec diplomatic = _diplomatic();

  /// `RBG 8047`: white on a green half and a yellow/red diagonal half.
  static final PlateSpec royalGuard = _royalGuard();

  static List<PlateSpec> get all => <PlateSpec>[
    private,
    government,
    taxi,
    police,
    diplomatic,
    royalGuard,
  ];

  static const List<_Part> _civilParts = <_Part>[
    _Part('type', BhutanAlphabets.letters, 2, dash: true),
    _Part('area', BhutanAlphabets.area, 1, dash: true),
    _Part('series', BhutanAlphabets.letters, 1),
    _Part('number', BhutanAlphabets.digits, 4),
  ];

  static const List<_Part> _policeParts = <_Part>[
    _Part('type', BhutanAlphabets.letters, 3, dash: true),
    _Part('number', BhutanAlphabets.digits, 4),
  ];

  static PlateSpec _civil(String id, _Row row, String caption, List<_Part> parts) {
    final int cells = parts.fold<int>(0, (int n, _Part p) => n + p.count + (p.dash ? 1 : 0));
    final double pitch = (row.right - row.left) / cells;
    final List<PlateSlot> slots = <PlateSlot>[];
    final List<PlateLabel> labels = <PlateLabel>[_caption(row, caption)];
    final List<PlateTextGroup> groups = <PlateTextGroup>[];
    int cell = 0;
    for (final _Part p in parts) {
      groups.add(PlateTextGroup(<int>[slots.length], key: p.key));
      slots.add(_field(p.alphabet, p.count, row.left + cell * pitch, pitch, row.top, row.box));
      cell += p.count;
      if (p.dash) {
        labels.add(
          PlateLabel(
            text: '-',
            box: PlateBox(row.left + cell * pitch, row.top, pitch, row.box),
            glyphHeight: row.box,
          ),
        );
        cell++;
      }
    }
    return PlateSpec(
      id: id,
      country: BhutanCountry.bhutan,
      canvasWidth: _Layout.width,
      canvasHeight: _Layout.height,
      panel: const PlatePanel(box: PlateBox(0, 0, 0, 0)),
      noPanel: true,
      slots: slots,
      labels: labels,
      textGroups: groups,
      resolveRegion: parts.any((_Part p) => p.key == 'area') ? BhutanRegions.captionOf : null,
    );
  }

  static PlateSpec _diplomatic() {
    const _Row row = _Layout.diplomatic;
    final double pitch = (row.right - row.left) / 6;
    return PlateSpec(
      id: 'bt.diplomatic',
      country: BhutanCountry.bhutan,
      canvasWidth: _Layout.width,
      canvasHeight: _Layout.height,
      panel: const PlatePanel(box: PlateBox(0, 0, 0, 0)),
      noPanel: true,
      slots: <PlateSlot>[
        _field(BhutanAlphabets.digits, 2, row.left, pitch, row.top, row.box),
        _field(BhutanAlphabets.digits, 2, row.left + 4 * pitch, pitch, row.top, row.box),
      ],
      labels: <PlateLabel>[
        _caption(row, 'ཚབ་'),
        PlateLabel(
          text: 'CD',
          box: PlateBox(row.left + 2 * pitch, row.top, 2 * pitch, row.box),
          glyphHeight: row.box,
        ),
      ],
      textGroups: const <PlateTextGroup>[
        PlateTextGroup(<int>[0], key: 'country'),
        PlateTextGroup(<int>[1], key: 'serial'),
      ],
    );
  }

  static PlateSpec _royalGuard() {
    const double top = _Layout.guardCy - _Layout.guardBox / 2;
    return PlateSpec(
      id: 'bt.royal_guard',
      country: BhutanCountry.bhutan,
      canvasWidth: _Layout.width,
      canvasHeight: _Layout.guardHeight,
      panel: const PlatePanel(box: PlateBox(0, 0, 0, 0)),
      noPanel: true,
      background: const PlateSection.columns(<PlatePart>[
        PlatePart(PlateSection.plain, end: _Layout.guardSplit),
        PlatePart(
          PlateSection.fill(
            PlateFill.stripes(
              <PlateFill>[
                PlateFill.color(BhutanColors.guardYellow),
                PlateFill.color(BhutanColors.guardRed),
              ],
              stops: <double>[_Layout.guardStop],
              angle: _Layout.guardAngle,
            ),
          ),
        ),
      ]),
      slots: <PlateSlot>[
        _field(
          BhutanAlphabets.letters,
          3,
          _Layout.guardLettersLeft,
          _Layout.guardLettersPitch,
          top,
          _Layout.guardBox,
        ),
        _field(
          BhutanAlphabets.digits,
          4,
          _Layout.guardDigitsLeft,
          _Layout.guardDigitsPitch,
          top,
          _Layout.guardBox,
        ),
      ],
      textGroups: const <PlateTextGroup>[
        PlateTextGroup(<int>[0], key: 'type'),
        PlateTextGroup(<int>[1], key: 'number'),
      ],
    );
  }
}
