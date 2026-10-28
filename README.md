FREE PALESTINE 🇮🇷🇵🇸 پاینده ایران

GO VEGAN 🌱

==================================

From the mighty people of Iran to the peaceful people of Bhutan to view examples:

https://platexample.ir/#/discover/bhutan

# bhutan_plate

Bhutan's private, government, taxi, police, diplomatic and Royal Guard plates for `plate_core`, with advisory validators.

## Install

```yaml
dependencies:
  plate_core: ^0.12.0
  bhutan_plate: ^0.1.0
```

## Use

```dart
import 'package:plate_core/plate_core.dart';
import 'package:bhutan_plate/bhutan_plate.dart';

PlateCanvas(
  spec: BhutanPlates.private,
  theme: BhutanThemes.private,
  validator: const BhutanValidator(),
  autoValidate: true,
  onChooseCharacter: noCharacterChooser,
);
```

## Contains

- `BhutanCountry` — country panel: `bhutan`.
- `BhutanPlates` — 6 plate specs: `private`, `government`, `taxi`, `police`, `diplomatic`, `royalGuard`.
- `BhutanThemes` — 6 themes: `private`, `government`, `taxi`, `police`, `diplomatic`, `royalGuard`.
- `BhutanValidator` — advisory validator; flags the frame, never blocks a keystroke.
- `BhutanDiplomaticValidator` — advisory validator; flags the frame, never blocks a keystroke.
- `BhutanRegions` — code table.

## Plates

Bhutan's current plates.

Four designs. The civil one (private, government, taxi, police) is a
Dzongkha caption over one row `BP-1-A1234` / `RBP-2300`, equal pitch with
the dashes as cells of their own; it differs only in the row's position,
the format and the caption, so one builder serves all four. Diplomatic has
a different row (`5 CD 8`), the Royal Guard a green half beside a
yellow/red diagonal half. Colour is the theme's: pair each with the
`BhutanThemes` member of the same name.

The plates have no printed frame except the taxi's (a theme ratio), so the
only painted background is the Royal Guard's, a `PlateSection` with a
diagonal stripes fill.

The Dzongkha captions are not transcribed from the article, which only
says "Representative" for the diplomatic one; they follow the shapes on the
photographs and are unverified. The Royal Guard plate is the 1970s one the
article pictures; the article's prose describes the current one as black,
orange and yellow. Not implemented: older numeric-only series.

## Part of plate

Painted by [`plate_core`](https://pub.dev/packages/plate_core); alphabets shared through [`plate_alphabet`](https://pub.dev/packages/plate_alphabet); optional character picker in [`plate_keypad`](https://pub.dev/packages/plate_keypad).

