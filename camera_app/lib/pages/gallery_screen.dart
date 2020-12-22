
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'camera_screen.dart';


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

  String _path = null;
  List<String> _imagesList = [];

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
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: (){
                _showPhotoLibrary(context);
              },
              icon: Icon(
                  Icons.add_box,
                  color: Colors.white,
                  size: 30,
                ),
              ),
          ),
        ],
        centerTitle: true,
        shadowColor: Colors.white24,
      ),
      body: SafeArea(
        child: _stringOrPic(context)
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

  Widget _stringOrPic(BuildContext context) {
    if (_path == null) {
      return Center(
        child: Text(
          "Utiliza el botón (+) para añadir fotos o pulsa el icono con la cámara"
              " para realizar una nueva foto.",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
    else {
      return _loadGallery(context);
    }
  }

  void _showPhotoLibrary(BuildContext context) async {
    final picker = ImagePicker();

    final file = await picker.getImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _path = file.path;
        _imagesList.add(_path);
      });
    }
  }

  void _oncapturePressed(context){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraScreen()
        )
    );
  }

  Widget _loadGallery(BuildContext context) {

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return Container (
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage(
                _imagesList[index],
              ),
              fit: BoxFit.cover
            )
          ),
        );
      },
      itemCount: _imagesList.length,
    );
  }
}