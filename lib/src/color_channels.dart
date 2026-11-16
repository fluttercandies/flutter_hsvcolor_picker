import 'package:material_ui/material_ui.dart';

extension ColorChannels on Color {
  int get _argb => toARGB32();

  int get alpha8 => (_argb >> 24) & 0xff;
  int get red8 => (_argb >> 16) & 0xff;
  int get green8 => (_argb >> 8) & 0xff;
  int get blue8 => _argb & 0xff;
}
