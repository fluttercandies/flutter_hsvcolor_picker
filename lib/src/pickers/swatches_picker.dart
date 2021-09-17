import 'package:flutter/material.dart';

/// Color swatches
class SwatchesPicker extends StatefulWidget {
  const SwatchesPicker({
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  final ValueChanged<Color> onChanged;

  @override
  _SwatchesPickerState createState() => _SwatchesPickerState();
}

class _SwatchesPickerState extends State<SwatchesPicker>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  void itemClick(Color item) => widget.onChanged(item);

  @override
  void initState() {
    super.initState();

    controller = TabController(
      initialIndex: 1,
      length: _swatches.length,
      vsync: this,
    );
  }

  Widget buildListView(Color? item) {
    if (item == null) return const Divider(height: 60.0);

    return Container(
      width: 40.0,
      height: 40.0,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: item,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey),
      ),
      child: InkWell(
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
        onTap: () => itemClick(item),
        splashColor: item,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: 470.0,
        height: 333.0,
        child: GridView.count(
          crossAxisCount: 4,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          padding: const EdgeInsets.all(4.0),
          children: _swatches.map(buildListView).toList(),
        ),
      ),
    );
  }
}

List<Color> _swatches = <Color>[
  //[
  Colors.transparent, //transparent
  Colors.black, //black
  Colors.black87, //black87
  Colors.black54, //black54
  Colors.black45, //black45
  Colors.black38, //black38
  Colors.black26, //black26
  Colors.black12, //black12
  Colors.white, //white
  Colors.white70, //white70
  Colors.white54, //white54
  Colors.white30, //white30
  Colors.white24, //white24
  Colors.white12, //white12
  Colors.white10, //white10
  //], [
  Colors.red, //red
  Colors.pink, //pink
  Colors.purple, //purple
  Colors.deepPurple, //deepPurple
  Colors.indigo, //indigo
  Colors.blue, //blue
  Colors.lightBlue, //lightBlue
  Colors.cyan, //cyan
  Colors.teal, //teal
  Colors.green, //green
  Colors.lightGreen, //lightGreen
  Colors.lime, //lime
  Colors.yellow, //yellow
  Colors.amber, //amber
  Colors.orange, //orange
  Colors.deepOrange, //deepOrange
  Colors.brown, //brown
  Colors.grey, //grey
  Colors.blueGrey, //blueGrey
  //null,
  Colors.redAccent, //redAccent
  Colors.pinkAccent, //pinkAccent
  Colors.purpleAccent, //purpleAccent
  Colors.deepPurpleAccent, //deepPurpleAccent
  Colors.indigoAccent, //indigoAccent
  Colors.blueAccent, //blueAccent
  Colors.lightBlueAccent, //lightBlueAccent
  Colors.cyanAccent, //cyanAccent
  Colors.tealAccent, //tealAccent
  Colors.greenAccent, //greenAccent
  Colors.lightGreenAccent, //lightGreenAccent
  Colors.limeAccent, //limeAccent
  Colors.yellowAccent, //yellowAccent
  Colors.amberAccent, //amberAccent
  Colors.orangeAccent, //orangeAccent
  Colors.deepOrangeAccent, //deepOrangeAccent
  //], [
  Colors.red[50]!, //red[50]
  Colors.red[100]!, //red[100]
  Colors.red[200]!, //red[200]
  Colors.red[300]!, //red[300]
  Colors.red[400]!, //red[400]
  Colors.red[500]!, //red[500]
  Colors.red[600]!, //red[600]
  Colors.red[700]!, //red[700]
  Colors.red[800]!, //red[800]
  Colors.red[900]!, //red[900]
  //null,
  Colors.redAccent[100]!, //redAccent[100]
  Colors.redAccent[200]!, //redAccent[200]
  Colors.redAccent[400]!, //redAccent[400]
  Colors.redAccent[700]!, //redAccent[700]
  //], [
  Colors.pink[50]!, //pink[50]
  Colors.pink[100]!, //pink[100]
  Colors.pink[200]!, //pink[200]
  Colors.pink[300]!, //pink[300]
  Colors.pink[400]!, //pink[400]
  Colors.pink[500]!, //pink[500]
  Colors.pink[600]!, //pink[600]
  Colors.pink[700]!, //pink[700]
  Colors.pink[800]!, //pink[800]
  Colors.pink[900]!, //pink[900]
  //null,
  Colors.pinkAccent[100]!, //pinkAccent[100]
  Colors.pinkAccent[200]!, //pinkAccent[200]
  Colors.pinkAccent[400]!, //pinkAccent[400]
  Colors.pinkAccent[700]!, //pinkAccent[700]
  //], [
  Colors.purple[50]!, //purple[50]
  Colors.purple[100]!, //purple[100]
  Colors.purple[200]!, //purple[200]
  Colors.purple[300]!, //purple[300]
  Colors.purple[400]!, //purple[400]
  Colors.purple[500]!, //purple[500]
  Colors.purple[600]!, //purple[600]
  Colors.purple[700]!, //purple[700]
  Colors.purple[800]!, //purple[800]
  Colors.purple[900]!, //purple[900]
  //null,
  Colors.purpleAccent[100]!, //purpleAccent[100]
  Colors.purpleAccent[200]!, //purpleAccent[200]
  Colors.purpleAccent[400]!, //purpleAccent[400]
  Colors.purpleAccent[700]!, //purpleAccent[700]
  //], [
  Colors.deepPurple[50]!, //deepPurple[50]
  Colors.deepPurple[100]!, //deepPurple[100]
  Colors.deepPurple[200]!, //deepPurple[200]
  Colors.deepPurple[300]!, //deepPurple[300]
  Colors.deepPurple[400]!, //deepPurple[400]
  Colors.deepPurple[500]!, //deepPurple[500]
  Colors.deepPurple[600]!, //deepPurple[600]
  Colors.deepPurple[700]!, //deepPurple[700]
  Colors.deepPurple[800]!, //deepPurple[800]
  Colors.deepPurple[900]!, //deepPurple[900]
  //null,
  Colors.deepPurpleAccent[100]!, //deepPurpleAccent[100]
  Colors.deepPurpleAccent[200]!, //deepPurpleAccent[200]
  Colors.deepPurpleAccent[400]!, //deepPurpleAccent[400]
  Colors.deepPurpleAccent[700]!, //deepPurpleAccent[700]
  //], [
  Colors.indigo[50]!, //indigo[50]
  Colors.indigo[100]!, //indigo[100]
  Colors.indigo[200]!, //indigo[200]
  Colors.indigo[300]!, //indigo[300]
  Colors.indigo[400]!, //indigo[400]
  Colors.indigo[500]!, //indigo[500]
  Colors.indigo[600]!, //indigo[600]
  Colors.indigo[700]!, //indigo[700]
  Colors.indigo[800]!, //indigo[800]
  Colors.indigo[900]!, //indigo[900]
  //null,
  Colors.indigoAccent[100]!, //indigoAccent[100]
  Colors.indigoAccent[200]!, //indigoAccent[200]
  Colors.indigoAccent[400]!, //indigoAccent[400]
  Colors.indigoAccent[700]!, //indigoAccent[700]
  //], [
  Colors.blue[50]!, //blue[50]
  Colors.blue[100]!, //blue[100]
  Colors.blue[200]!, //blue[200]
  Colors.blue[300]!, //blue[300]
  Colors.blue[400]!, //blue[400]
  Colors.blue[500]!, //blue[500]
  Colors.blue[600]!, //blue[600]
  Colors.blue[700]!, //blue[700]
  Colors.blue[800]!, //blue[800]
  Colors.blue[900]!, //blue[900]
  //null,
  Colors.blueAccent[100]!, //blueAccent[100]
  Colors.blueAccent[200]!, //blueAccent[200]
  Colors.blueAccent[400]!, //blueAccent[400]
  Colors.blueAccent[700]!, //blueAccent[700]
  //], [
  Colors.lightBlue[50]!, //lightBlue[50]
  Colors.lightBlue[100]!, //lightBlue[100]
  Colors.lightBlue[200]!, //lightBlue[200]
  Colors.lightBlue[300]!, //lightBlue[300]
  Colors.lightBlue[400]!, //lightBlue[400]
  Colors.lightBlue[500]!, //lightBlue[500]
  Colors.lightBlue[600]!, //lightBlue[600]
  Colors.lightBlue[700]!, //lightBlue[700]
  Colors.lightBlue[800]!, //lightBlue[800]
  Colors.lightBlue[900]!, //lightBlue[900]
  //null,
  Colors.lightBlueAccent[100]!, //lightBlueAccent[100]
  Colors.lightBlueAccent[200]!, //lightBlueAccent[200]
  Colors.lightBlueAccent[400]!, //lightBlueAccent[400]
  Colors.lightBlueAccent[700]!, //lightBlueAccent[700]
  //], [
  Colors.cyan[50]!, //cyan[50]
  Colors.cyan[100]!, //cyan[100]
  Colors.cyan[200]!, //cyan[200]
  Colors.cyan[300]!, //cyan[300]
  Colors.cyan[400]!, //cyan[400]
  Colors.cyan[500]!, //cyan[500]
  Colors.cyan[600]!, //cyan[600]
  Colors.cyan[700]!, //cyan[700]
  Colors.cyan[800]!, //cyan[800]
  Colors.cyan[900]!, //cyan[900]
  //null,
  Colors.cyanAccent[100]!, //cyanAccent[100]
  Colors.cyanAccent[200]!, //cyanAccent[200]
  Colors.cyanAccent[400]!, //cyanAccent[400]
  Colors.cyanAccent[700]!, //cyanAccent[700]
  //], [
  Colors.teal[50]!, //teal[50]
  Colors.teal[100]!, //teal[100]
  Colors.teal[200]!, //teal[200]
  Colors.teal[300]!, //teal[300]
  Colors.teal[400]!, //teal[400]
  Colors.teal[500]!, //teal[500]
  Colors.teal[600]!, //teal[600]
  Colors.teal[700]!, //teal[700]
  Colors.teal[800]!, //teal[800]
  Colors.teal[900]!, //teal[900]
  //null,
  Colors.tealAccent[100]!, //tealAccent[100]
  Colors.tealAccent[200]!, //tealAccent[200]
  Colors.tealAccent[400]!, //tealAccent[400]
  Colors.tealAccent[700]!, //tealAccent[700]
  //], [
  Colors.green[50]!, //green[50]
  Colors.green[100]!, //green[100]
  Colors.green[200]!, //green[200]
  Colors.green[300]!, //green[300]
  Colors.green[400]!, //green[400]
  Colors.green[500]!, //green[500]
  Colors.green[600]!, //green[600]
  Colors.green[700]!, //green[700]
  Colors.green[800]!, //green[800]
  Colors.green[900]!, //green[900]
  //null,
  Colors.greenAccent[100]!, //greenAccent[100]
  Colors.greenAccent[200]!, //greenAccent[200]
  Colors.greenAccent[400]!, //greenAccent[400]
  Colors.greenAccent[700]!, //greenAccent[700]
  //], [
  Colors.lightGreen[50]!, //lightGreen[50]
  Colors.lightGreen[100]!, //lightGreen[100]
  Colors.lightGreen[200]!, //lightGreen[200]
  Colors.lightGreen[300]!, //lightGreen[300]
  Colors.lightGreen[400]!, //lightGreen[400]
  Colors.lightGreen[500]!, //lightGreen[500]
  Colors.lightGreen[600]!, //lightGreen[600]
  Colors.lightGreen[700]!, //lightGreen[700]
  Colors.lightGreen[800]!, //lightGreen[800]
  Colors.lightGreen[900]!, //lightGreen[900]
  //null,
  Colors.lightGreenAccent[100]!, //lightGreenAccent[100]
  Colors.lightGreenAccent[200]!, //lightGreenAccent[200]
  Colors.lightGreenAccent[400]!, //lightGreenAccent[400]
  Colors.lightGreenAccent[700]!, //lightGreenAccent[700]
  //], [
  Colors.lime[50]!, //lime[50]
  Colors.lime[100]!, //lime[100]
  Colors.lime[200]!, //lime[200]
  Colors.lime[300]!, //lime[300]
  Colors.lime[400]!, //lime[400]
  Colors.lime[500]!, //lime[500]
  Colors.lime[600]!, //lime[600]
  Colors.lime[700]!, //lime[700]
  Colors.lime[800]!, //lime[800]
  Colors.lime[900]!, //lime[900]
  //null,
  Colors.limeAccent[100]!, //limeAccent[100]
  Colors.limeAccent[200]!, //limeAccent[200]
  Colors.limeAccent[400]!, //limeAccent[400]
  Colors.limeAccent[700]!, //limeAccent[700]
  //], [
  Colors.yellow[50]!, //yellow[50]
  Colors.yellow[100]!, //yellow[100]
  Colors.yellow[200]!, //yellow[200]
  Colors.yellow[300]!, //yellow[300]
  Colors.yellow[400]!, //yellow[400]
  Colors.yellow[500]!, //yellow[500]
  Colors.yellow[600]!, //yellow[600]
  Colors.yellow[700]!, //yellow[700]
  Colors.yellow[800]!, //yellow[800]
  Colors.yellow[900]!, //yellow[900]
  //null,
  Colors.yellowAccent[100]!, //yellowAccent[100]
  Colors.yellowAccent[200]!, //yellowAccent[200]
  Colors.yellowAccent[400]!, //yellowAccent[400]
  Colors.yellowAccent[700]!, //yellowAccent[700]
  //], [
  Colors.amber[50]!, //amber[50]
  Colors.amber[100]!, //amber[100]
  Colors.amber[200]!, //amber[200]
  Colors.amber[300]!, //amber[300]
  Colors.amber[400]!, //amber[400]
  Colors.amber[500]!, //amber[500]
  Colors.amber[600]!, //amber[600]
  Colors.amber[700]!, //amber[700]
  Colors.amber[800]!, //amber[800]
  Colors.amber[900]!, //amber[900]
  //null,
  Colors.amberAccent[100]!, //amberAccent[100]
  Colors.amberAccent[200]!, //amberAccent[200]
  Colors.amberAccent[400]!, //amberAccent[400]
  Colors.amberAccent[700]!, //amberAccent[700]
  //], [
  Colors.orange[50]!, //orange[50]
  Colors.orange[100]!, //orange[100]
  Colors.orange[200]!, //orange[200]
  Colors.orange[300]!, //orange[300]
  Colors.orange[400]!, //orange[400]
  Colors.orange[500]!, //orange[500]
  Colors.orange[600]!, //orange[600]
  Colors.orange[700]!, //orange[700]
  Colors.orange[800]!, //orange[800]
  Colors.orange[900]!, //orange[900]
  //null,
  Colors.orangeAccent[100]!, //orangeAccent[100]
  Colors.orangeAccent[200]!, //orangeAccent[200]
  Colors.orangeAccent[400]!, //orangeAccent[400]
  Colors.orangeAccent[700]!, //orangeAccent[700]
  //], [
  Colors.deepOrange[50]!, //deepOrange[50]
  Colors.deepOrange[100]!, //deepOrange[100]
  Colors.deepOrange[200]!, //deepOrange[200]
  Colors.deepOrange[300]!, //deepOrange[300]
  Colors.deepOrange[400]!, //deepOrange[400]
  Colors.deepOrange[500]!, //deepOrange[500]
  Colors.deepOrange[600]!, //deepOrange[600]
  Colors.deepOrange[700]!, //deepOrange[700]
  Colors.deepOrange[800]!, //deepOrange[800]
  Colors.deepOrange[900]!, //deepOrange[900]
  //null,
  Colors.deepOrangeAccent[100]!, //deepOrangeAccent[100]
  Colors.deepOrangeAccent[200]!, //deepOrangeAccent[200]
  Colors.deepOrangeAccent[400]!, //deepOrangeAccent[400]
  Colors.deepOrangeAccent[700]!, //deepOrangeAccent[700]
  //], [
  Colors.brown[50]!, //brown[50]
  Colors.brown[100]!, //brown[100]
  Colors.brown[200]!, //brown[200]
  Colors.brown[300]!, //brown[300]
  Colors.brown[400]!, //brown[400]
  Colors.brown[500]!, //brown[500]
  Colors.brown[600]!, //brown[600]
  Colors.brown[700]!, //brown[700]
  Colors.brown[800]!, //brown[800]
  Colors.brown[900]!, //brown[900]
  //], [
  Colors.grey[50]!, //grey[50]
  Colors.grey[100]!, //grey[100]
  Colors.grey[200]!, //grey[200]
  Colors.grey[300]!, //grey[300]
  Colors.grey[400]!, //grey[400]
  Colors.grey[500]!, //grey[500]
  Colors.grey[600]!, //grey[600]
  Colors.grey[700]!, //grey[700]
  Colors.grey[800]!, //grey[800]
  Colors.grey[900]!, //grey[900]
  //], [
  Colors.blueGrey[50]!, //blueGrey[50]
  Colors.blueGrey[100]!, //blueGrey[100]
  Colors.blueGrey[200]!, //blueGrey[200]
  Colors.blueGrey[300]!, //blueGrey[300]
  Colors.blueGrey[400]!, //blueGrey[400]
  Colors.blueGrey[500]!, //blueGrey[500]
  Colors.blueGrey[600]!, //blueGrey[600]
  Colors.blueGrey[700]!, //blueGrey[700]
  Colors.blueGrey[800]!, //blueGrey[800]
  Colors.blueGrey[900]!, //blueGrey[900]
  //]
];
