import "package:flutter/material.dart";
import "package:flutter/cupertino.dart";
import "Pages/SliderPickerPage.dart";
import "Pages/PalettePickerPage.dart";
import "Pages/HSVPickerPage.dart";
import "Pages/RGBPickerPage.dart";
import "Pages/WheelPickerPage.dart";
import "Pages/PaletteHuePickerPage.dart";
import "Pages/PaletteSaturationPickerPage.dart";
import "Pages/PaletteValuePickerPage.dart";
import "Pages/HexPickerPage.dart";
import "Pages/AlphaPickerPage.dart";
import "Pages/SwatchesPickerPage.dart";
import "Pages/ColorPickerPage.dart";

class MainPage extends StatefulWidget {

  @override
  MainPageState createState() => new MainPageState();
}

class MainPageState extends State<MainPage> {
  
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  int index = 11;
  Widget get page => this.items.firstWhere((item) => item==null? false: item.index==this.index).page;
  List<MainItem> items = [
    new MainItem(index: 0, icon: Icons.linear_scale, text: "Slider", page: new SliderPickerPage()),
    new MainItem(index: 1, icon: Icons.gradient, text: "Palette", page: new PalettePickerPage()),
    null,
    new MainItem(index: 2, icon: Icons.tune, text: "RGB Picker", page: new RGBPickerPage()),
    new MainItem(index: 3, icon: Icons.tune, text: "HSV Picker", page: new HSVPickerPage()),
    new MainItem(index: 4, icon: Icons.tune, text: "Wheel Picker", page: new WheelPickerPage()),
    null,
    new MainItem(index: 5, icon: Icons.color_lens, text: "Palette Hue Picker", page: new PaletteHuePickerPage()),     
    new MainItem(index: 6, icon: Icons.color_lens, text: "Palette Saturation Picker", page: new PaletteSaturationPickerPage()),
    new MainItem(index: 7, icon: Icons.color_lens, text: "Palette Value Picker", page: new PaletteValuePickerPage()),
    null,
    new MainItem(index: 8, icon: Icons.mode_edit, text: "Hex Picker", page: new HexPickerPage()),
    new MainItem(index: 9, icon: Icons.mode_edit, text: "Alpha Picker", page: new AlphaPickerPage()),
    new MainItem(index: 10, icon: Icons.mode_edit, text: "Swatches Picker", page: new SwatchesPickerPage()),
    null,
    new MainItem(index: 11, icon: Icons.color_lens, text: "Color Picker", page: new ColorPickerPage()),
  ];  
   
  void iconButtonOnPressed() => this.scaffoldKey.currentState.openDrawer();
  void listTileOnTap(MainItem item){
   this.index=item.index;
   //Navigator.of(context).pop();//Navigator
  } 

  //Theme
  bool isDark = false;
  ThemeData get theme => isDark? themeDark:themeLight;
  ThemeData themeLight = new ThemeData(brightness: Brightness.light, platform: TargetPlatform.iOS);
  ThemeData themeDark = new ThemeData(brightness: Brightness.dark, platform: TargetPlatform.iOS);
  void setTheme() => super.setState(()=>isDark =! isDark);   
 
 
  Widget buildAppBar(){
    return new AppBar(
      elevation: 0.0,
      backgroundColor: this.theme.scaffoldBackgroundColor,
     
      //Center
      title: new Center(
        child: new Text("HSV Color", textAlign: TextAlign.center, style: this.theme.textTheme.headline)
      ),
        
      //Left
      leading: new IconButton(
        onPressed: this.iconButtonOnPressed,
        icon: new IconTheme(
          data: this.theme.iconTheme,
          child: new Icon(Icons.dehaze)
        )
      ),

      //Right
      actions: <Widget>[
        new IconButton(
          onPressed: this.iconButtonOnPressed,
          icon: new IconTheme(
            data: this.theme.iconTheme,
            child: new Icon(Icons.dehaze)
          )
        )
      ]

    );
  }
 
  Widget buildDrawer(){
    return new Drawer(
      child: new DecoratedBox(     
        decoration: BoxDecoration(color: this.theme.cardColor),
        child: new Column(
          children: <Widget>[
           
            //Header
            this.buildDrawerHeader(),
           
            //List
            new Expanded(
              child: new ListView(
                children: this.items.map(this.buildListViewItem).toList()
              )
            )

          ]
        )
      )
    );
  }

  Widget buildDrawerHeader(){
    return new DrawerHeader(
      decoration : new BoxDecoration(color: this.theme.accentColor),
      child : new Stack(
        children : <Widget>[
        
          //Avatar
          new Align(
            alignment : Alignment.bottomLeft,
            child : new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment : CrossAxisAlignment.start,
              children : <Widget>[
                new CircleAvatar(
                  radius : 34.0, 
                  backgroundColor: this.theme.cardColor,
                  backgroundImage: new AssetImage("packages/avatar.jpg")
                ),
                new Container(height : 10.0),
                new Text(
                  "淹死的鱼ysdy44", 
                  style : new TextStyle(color : Colors.white, fontSize : 18.0)
                )
              ]
            )
          ),

          //Button
         new Align(
            alignment : Alignment.bottomRight,
            child : new RaisedButton(
              onPressed: this.setTheme,
              color : this.theme.accentColor,
              shape : new StadiumBorder(),
              child : new Text(
                this.theme.brightness==Brightness.dark? "Dark": "Light", 
                style : new TextStyle(fontSize : 16.0,color : Colors.white)
              )
            )
          )


        ]
      )
    );
  }

  Widget buildDrawer22(){
    return new Drawer(
      child: new DecoratedBox(     
        decoration: BoxDecoration(color: this.theme.cardColor),
        child: CustomScrollView(
          scrollDirection: Axis.vertical,
          reverse: false,
          controller: ScrollController(),
          primary: false,
          physics: ScrollPhysics(),
          shrinkWrap: false,
          slivers: <Widget>[
            
            //Body
            new SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  this.buildDrawerHeader()
                ]
              )
            ),

            //Body
            new SliverList(
              delegate: SliverChildListDelegate(
                this.items.map(this.buildListViewItem).toList()
              )
            )
       
          ]
        )
      )
    );






  }



  Widget buildListViewItem(MainItem item){
    if(item==null) return new Divider(height: 6.0);

    return new ListTile(
      selected: item.index==this.index,
      leading: new Icon(item.icon),
      title: new Text(item.text),
      onTap: ()=>super.setState(()=>this.listTileOnTap(item))
    );
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "HSV Color",
      theme: this.theme,
      home: new Scaffold(
        key: this.scaffoldKey,
        backgroundColor: this.theme.scaffoldBackgroundColor,
        body: this.page,   
        appBar: this.buildAppBar(),
        drawer: this.buildDrawer22()
      )
    );
  }
}
 
class MainItem{
  final int index;
  final IconData icon;
  final String text;
  final Widget page;

  MainItem({
    this.index,
    this.icon,
    this.text,
    this.page
  });
}

