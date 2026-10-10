## [1.6.0]

* Accept six-digit RGB HEX input with optional `#`, `0x`, or `0X` prefixes and
  surrounding whitespace. Reject malformed input without changing the color.
* Select colors on slider, palette, and wheel taps as well as drags, and align
  wheel input coordinates with the painted hues.
* Wait for slider, palette, and wheel gestures to be accepted before changing the color,
  so cancelled touches do not select a value. Keep wheel drags tied to the
  original touched region when crossing into the palette.
* Make the HEX picker constructor const, retain and dispose its editing
  resources, and synchronize picker state when the parent changes the color.
* Remove an unused swatches animation controller.
* Fix `PaletteHuePicker` hue colors for dark or desaturated palette selections.
* Label HSV saturation and value as percentages and use V for value.
* Preserve selected example colors, make picker pages scroll above the keyboard,
  keep drawer ink visible, and correct asset filename capitalization.
* Allow Dart 3 while retaining the package's Flutter 2.10 / Dart 2.16 minimum.
  The native example requires Flutter 3.47 and uses AGP 9.2.1 with built-in Kotlin,
  Gradle 9.7.1, and an iOS 15 deployment target.
* Add picker interaction, lifecycle, input, and example layout regressions and
  clarify compatibility and input behavior in the README.

## [1.5.1]

* Update example app.
* Widen `flutter_lints` constraints.

## [1.5.0]

* Add `showPalette` to `WheelPicker`.
* Add `paletteHeight` to `ColorPicker`, `PaletteHuePicker`, `PaletteSaturationPicker`, and `PaletteValuePicker`.

## [1.4.0+1]

* Update image paths in readme.

## [1.4.0]

* Update dependencies.
* Rename to `main` branch, and update links in readme.

## [1.3.0]

* Expose some decoration properties for PaletteHuePicker.
* Update deprecated theme variables
* Updates in example app.

## [1.2.3]

* Fix bug on color change where previously set alpha value was ignored.

## [1.2.2]

* Update example app.

## [1.2.1]

* Add `pickerOrientation` to `ColorPicker` to lock the orientation if needed.
* Improve documentation.

## [1.2.0]

* Update deprecated theme color (accentColor -> colorScheme.secondary).
* Improve UI.
* Refactor folder structure.

## [1.1.0]

* Fix ColorPicker not shown in landscape mode.
* Fix alpha slider not changing the alpha value of color.
* Add initialPicker for changing the first picker of ColorPicker.

## [1.0.2]

* Publishing test.
## [1.0.1]

* Add .github files.
## [1.0.0]

* Migrate to null safety.

## [0.1.1]

* Describe initial release.

## [0.1.2]

* Some bugs have been improved.
