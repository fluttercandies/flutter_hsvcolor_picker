# flutter_hsvcolor_picker

An HSV color picker designed for your Flutter app.

Pickers: RGB, HSV, Color Wheel, Palette Hue, Palette Saturation, Palette Value, Swatches.

![](https://raw.githubusercontent.com/fluttercandies/flutter_hsvcolor_picker/main/screenshot/phone.png)

## Getting Started
  ![](https://raw.githubusercontent.com/fluttercandies/flutter_hsvcolor_picker/main/screenshot/logo.png)


### Installation

https://pub.dev/packages/flutter_hsvcolor_picker/install


### Example

```dart

import "package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart";

ColorPicker(
  color: Colors.blue,
  onChanged: (value){ },
  initialPicker: Picker.paletteHue,
)
```

For a more detailed example, head over to: https://github.com/fluttercandies/flutter_hsvcolor_picker/tree/main/example/lib/complex_example

![](https://raw.githubusercontent.com/fluttercandies/flutter_hsvcolor_picker/main/screenshot/design.png)

## Development

Use FVM for the repository toolchain. The canonical formatter width is 120 columns:

```sh
fvm dart format --line-length 120 .
fvm dart format --line-length 120 --output=none --set-exit-if-changed .
fvm dart analyze
fvm flutter test
(cd example && fvm flutter build apk --debug)
```

The example also has native runner tests. Current Xcode versions require command-scoped iOS 17 and macOS 14 deployment targets
for these tests; the checked-in platform minimums stay unchanged:

```sh
xcodebuild test -project example/macos/Runner.xcodeproj -scheme Runner -destination 'platform=macOS,arch=arm64' \
  -parallel-testing-enabled NO -enableCodeCoverage YES -only-testing:RunnerTests MACOSX_DEPLOYMENT_TARGET=14.0
xcodebuild test -project example/ios/Runner.xcodeproj -scheme Runner \
  -destination 'platform=iOS Simulator,id=<simulator-udid>' \
  -parallel-testing-enabled NO -enableCodeCoverage YES -only-testing:RunnerTests IPHONEOS_DEPLOYMENT_TARGET=17.0
```
