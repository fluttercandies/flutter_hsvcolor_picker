import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'pages/slider_picker_page.dart';
import 'pages/palette_picker_page.dart';
import 'pages/hsv_picker_page.dart';
import 'pages/rgb_picker_page.dart';
import 'pages/swatches_picker_page.dart';
import 'pages/wheel_picker_page.dart';
import 'pages/palette_hue_picker_page.dart';
import 'pages/palette_saturation_picker_page.dart';
import 'pages/palette_value_picker_page.dart';
import 'pages/hex_picker_page.dart';
import 'pages/alpha_picker_page.dart';
import 'pages/color_picker_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  int index = 11;
  Widget? get page => this
      .items
      .firstWhere((item) => item == null ? false : item.index == this.index)
      ?.page;
  List<MainItem?> items = [
    MainItem(
      index: 0,
      icon: Icons.linear_scale,
      text: 'Slider',
      page: const SliderPickerPage(),
    ),
    MainItem(
      index: 1,
      icon: Icons.gradient,
      text: 'Palette',
      page: PalettePickerPage(),
    ),
    null,
    MainItem(
      index: 2,
      icon: Icons.tune,
      text: 'RGB Picker',
      page: const RGBPickerPage(),
    ),
    MainItem(
      index: 3,
      icon: Icons.tune,
      text: 'HSV Picker',
      page: const HSVPickerPage(),
    ),
    MainItem(
      index: 4,
      icon: Icons.tune,
      text: 'Wheel Picker',
      page: const WheelPickerPage(),
    ),
    null,
    MainItem(
      index: 5,
      icon: Icons.color_lens,
      text: 'Palette Hue Picker',
      page: const PaletteHuePickerPage(),
    ),
    MainItem(
      index: 6,
      icon: Icons.color_lens,
      text: 'Palette Saturation Picker',
      page: const PaletteSaturationPickerPage(),
    ),
    MainItem(
      index: 7,
      icon: Icons.color_lens,
      text: 'Palette Value Picker',
      page: const PaletteValuePickerPage(),
    ),
    null,
    MainItem(
      index: 8,
      icon: Icons.mode_edit,
      text: 'Hex Picker',
      page: const HexPickerPage(),
    ),
    MainItem(
      index: 9,
      icon: Icons.mode_edit,
      text: 'Alpha Picker',
      page: const AlphaPickerPage(),
    ),
    MainItem(
      index: 10,
      icon: Icons.mode_edit,
      text: 'Swatches Picker',
      page: const SwatchesPickerPage(),
    ),
    null,
    MainItem(
      index: 11,
      icon: Icons.color_lens,
      text: 'Color Picker',
      page: const ColorPickerPage(),
    ),
  ];

  void iconButtonOnPressed() => this.scaffoldKey.currentState?.openDrawer();
  void listTileOnTap(MainItem item) {
    this.index = item.index;
    // Navigator.of(context).pop();//Navigator
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
      backgroundColor: this.theme.scaffoldBackgroundColor,

      // Center
      title: Center(
        child: Text(
          'HSV Color',
          textAlign: TextAlign.center,
          style: this.theme.textTheme.headline5,
        ),
      ),

      // Left
      leading: IconButton(
        onPressed: this.iconButtonOnPressed,
        icon: IconTheme(
          data: this.theme.iconTheme,
          child: const Icon(Icons.dehaze),
        ),
      ),

      // Right
      actions: <Widget>[
        IconButton(
          onPressed: this.iconButtonOnPressed,
          icon: IconTheme(
            data: this.theme.iconTheme,
            child: const Icon(Icons.dehaze),
          ),
        )
      ],
    );
  }

  Widget buildDrawer() {
    return Drawer(
      child: DecoratedBox(
        decoration: BoxDecoration(color: this.theme.cardColor),
        child: Column(
          children: <Widget>[
            // Header
            this.buildDrawerHeader(),

            // List
            Expanded(
              child: ListView(
                children: this.items.map(this.buildListViewItem).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(color: this.theme.accentColor),
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
                  backgroundColor: this.theme.cardColor,
                  backgroundImage: const AssetImage('packages/avatar.jpg'),
                ),
                Container(height: 10.0),
                const Text(
                  '淹死的鱼ysdy44',
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
                )
              ],
            ),
          ),

          // Button
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: this.setTheme,
              style: ElevatedButton.styleFrom(
                primary: this.theme.accentColor,
                shape: const StadiumBorder(),
              ),
              child: Text(
                this.theme.brightness == Brightness.dark ? 'Dark' : 'Light',
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
        decoration: BoxDecoration(color: this.theme.cardColor),
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
                <Widget>[this.buildDrawerHeader()],
              ),
            ),

            // Body
            SliverList(
              delegate: SliverChildListDelegate(
                this.items.map(this.buildListViewItem).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildListViewItem(MainItem? item) {
    if (item == null) return const Divider(height: 6.0);

    return ListTile(
      selected: item.index == this.index,
      leading: Icon(item.icon),
      title: Text(item.text),
      onTap: () => super.setState(
        () => this.listTileOnTap(item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HSV Color',
      theme: this.theme,
      home: Scaffold(
        key: this.scaffoldKey,
        backgroundColor: this.theme.scaffoldBackgroundColor,
        body: this.page,
        appBar: this.buildAppBar(),
        drawer: this.buildDrawer22(),
      ),
    );
  }
}

class MainItem {
  final int index;
  final IconData icon;
  final String text;
  final Widget page;

  MainItem({
    required this.index,
    required this.icon,
    required this.text,
    required this.page,
  });
}
