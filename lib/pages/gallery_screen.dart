import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app2/pages/camera_screen.dart';

class GalleryScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
              "Galería"),

        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          _onPressed(context);
        },
        child: Icon(
          Icons.add_a_photo_rounded,
          color: Colors.black,
          size: 30,
        ),
        backgroundColor: Colors.white,
      ),
    );

  }

  Future _onPressed (BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context){
      return CameraScreen();
    }));

  }

}