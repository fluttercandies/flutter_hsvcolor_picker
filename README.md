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

import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

ColorPicker(
  color: Colors.blue,
  onChanged: (value) {
    // Save the selected color in your app state.
  },
  initialPicker: Picker.paletteHue,
)
```

`color` sets the initial selection and updates it when the parent passes a new color. `initialPicker` selects the first picker only. Sliders and the wheel accept taps and drags. The HEX field accepts six RGB digits, optionally prefixed with `#` or `0x`; use the alpha slider for transparency.

For a more detailed example, head over to: https://github.com/fluttercandies/flutter_hsvcolor_picker/tree/main/example/lib/complex_example

![](https://raw.githubusercontent.com/fluttercandies/flutter_hsvcolor_picker/main/screenshot/design.png)
