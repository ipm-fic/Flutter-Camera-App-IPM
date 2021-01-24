import 'package:camera_app/src/ui/gallery_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera_app/src/resources/sizeable.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _gotoHome(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
          child: Icon(
        Icons.camera,
        size: adaptView(150.0, 80.0),
        color: Colors.white,
      )),
    );
  }

  void _gotoHome(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return MyHomePage(
          title: 'Galería',
        );
      }));
    });
  }
}
