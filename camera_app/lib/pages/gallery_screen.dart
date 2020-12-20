import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
        shadowColor: Colors.white24,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverStaggeredGrid.countBuilder(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
              itemBuilder: (context,index){
                return ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  //child: Image.asset(""),
                );
              },
              itemCount: 10)
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){_oncapturePressed(context);},
        tooltip: 'Hacer foto',
        backgroundColor: Colors.white,
        child: Icon(
          CupertinoIcons.photo_camera_solid,
          color: Colors.black,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _oncapturePressed(context){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraScreen()
        )
    );
  }
}