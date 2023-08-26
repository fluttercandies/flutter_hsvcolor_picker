import 'package:flutter/material.dart';

import 'alpha_picker_page.dart';
import 'color_picker_page.dart';
import 'hex_picker_page.dart';
import 'hsv_picker_page.dart';
import 'palette_hue_picker_page.dart';
import 'palette_picker_page.dart';
import 'palette_saturation_picker_page.dart';
import 'palette_value_picker_page.dart';
import 'rgb_picker_page.dart';
import 'slider_picker_page.dart';
import 'swatches_picker_page.dart';
import 'wheel_picker_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MainPage();
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int index = 0;
  Widget? get page => items
      .firstWhere((item) => item == null ? false : item.index == index)
      ?.page;
  List<_MainItem?> items = [
    _MainItem(
      index: 0,
      icon: Icons.color_lens,
      text: 'Color Picker',
      page: const ColorPickerPage(),
    ),
    null,
    _MainItem(
      index: 1,
      icon: Icons.tune,
      text: 'RGB Picker',
      page: const RGBPickerPage(),
    ),
    _MainItem(
      index: 2,
      icon: Icons.tune,
      text: 'HSV Picker',
      page: const HSVPickerPage(),
    ),
    _MainItem(
      index: 3,
      icon: Icons.tune,
      text: 'Wheel Picker',
      page: const WheelPickerPage(),
    ),
    null,
    _MainItem(
      index: 4,
      icon: Icons.color_lens,
      text: 'Palette Hue Picker',
      page: const PaletteHuePickerPage(),
    ),
    _MainItem(
      index: 5,
      icon: Icons.color_lens,
      text: 'Palette Saturation Picker',
      page: const PaletteSaturationPickerPage(),
    ),
    _MainItem(
      index: 6,
      icon: Icons.color_lens,
      text: 'Palette Value Picker',
      page: const PaletteValuePickerPage(),
    ),
    null,
    _MainItem(
      index: 7,
      icon: Icons.mode_edit,
      text: 'Swatches Picker',
      page: const SwatchesPickerPage(),
    ),
    _MainItem(
      index: 8,
      icon: Icons.mode_edit,
      text: 'Hex Picker',
      page: const HexPickerPage(),
    ),
    _MainItem(
      index: 9,
      icon: Icons.mode_edit,
      text: 'Alpha Picker',
      page: const AlphaPickerPage(),
    ),
    null,
    _MainItem(
      index: 10,
      icon: Icons.linear_scale,
      text: 'Slider',
      page: const SliderPickerPage(),
    ),
    _MainItem(
      index: 11,
      icon: Icons.gradient,
      text: 'Palette',
      page: PalettePickerPage(),
    ),
  ];

  void iconButtonOnPressed() => scaffoldKey.currentState?.openDrawer();
  void listTileOnTap(_MainItem item) {
    index = item.index;
    scaffoldKey.currentState?.openEndDrawer();
  }

  // Theme
  bool isDark = false;
  ThemeData get theme => isDark ? themeDark : themeLight;
  ThemeData themeLight =
      ThemeData(brightness: Brightness.light, platform: TargetPlatform.iOS);
  ThemeData themeDark =
      ThemeData(brightness: Brightness.dark, platform: TargetPlatform.iOS);
  void setTheme() => super.setState(() => isDark = !isDark);

  PreferredSizeWidget buildAppBar() {
    return AppBar(
      elevation: 0.0,
      backgroundColor: theme.scaffoldBackgroundColor,

      // Center
      title: Center(
        child: Text(
          'HSV Color',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall,
        ),
      ),

      // Left
      leading: IconButton(
        onPressed: iconButtonOnPressed,
        icon: IconTheme(
          data: theme.iconTheme,
          child: const Icon(Icons.dehaze),
        ),
      ),

      // Right
      actions: <Widget>[
        IconButton(
          onPressed: iconButtonOnPressed,
          icon: IconTheme(
            data: theme.iconTheme,
            child: const Icon(Icons.dehaze),
          ),
        )
      ],
    );
  }

  Widget buildDrawer() {
    return Drawer(
      child: DecoratedBox(
        decoration: BoxDecoration(color: theme.cardColor),
        child: Column(
          children: <Widget>[
            // Header
            buildDrawerHeader(),

            // List
            Expanded(
              child: ListView(
                children: items.map(buildListViewItem).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildDrawerHeader() {
    return DrawerHeader(
      decoration: const BoxDecoration(color: Colors.blue),
      child: Stack(
        children: <Widget>[
          // Avatar
          Align(
            alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CircleAvatar(
                  radius: 34.0,
                  backgroundColor: theme.cardColor,
                  backgroundImage: const AssetImage('packages/avatar.jpg'),
                ),
                const SizedBox(height: 10.0),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    '淹死的鱼ysdy44',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                )
              ],
            ),
          ),

          // Button
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: setTheme,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade400,
                shape: const StadiumBorder(),
              ),
              child: Text(
                theme.brightness == Brightness.dark ? 'Dark' : 'Light',
                style: const TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildDrawer22() {
    return Drawer(
      child: DecoratedBox(
        decoration: BoxDecoration(color: theme.cardColor),
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          reverse: false,
          controller: ScrollController(),
          primary: false,
          physics: const ScrollPhysics(),
          shrinkWrap: false,
          slivers: <Widget>[
            // Body
            SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[buildDrawerHeader()],
              ),
            ),

            // Body
            SliverList(
              delegate: SliverChildListDelegate(
                items.map(buildListViewItem).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildListViewItem(_MainItem? item) {
    if (item == null) return const Divider(height: 6.0);

    return ListTile(
      selected: item.index == index,
      leading: Icon(item.icon),
      title: Text(item.text),
      onTap: () => super.setState(
        () => listTileOnTap(item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HSV Color',
      theme: theme,
      home: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.scaffoldBackgroundColor,
        body: page,
        appBar: buildAppBar(),
        drawer: buildDrawer22(),
      ),
    );
  }
}

class _MainItem {
  _MainItem({
    required this.index,
    required this.icon,
    required this.text,
    required this.page,
  });

  final int index;
  final IconData icon;
  final String text;
  final Widget page;
}
