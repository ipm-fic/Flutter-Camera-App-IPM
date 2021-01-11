import 'dart:io';
import 'dart:ui';
import 'package:camera_app/pages/output_screen.dart';
import 'package:flutter/material.dart';

class PreviewScreen extends StatelessWidget {
  final String imgPath;
  final double aspectRatio;

  const PreviewScreen({Key key, this.imgPath, this.aspectRatio})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(

      ),
      body: Container(
        child: Align(
          alignment: Alignment.center,
          child: SafeArea(
            child: Image.file(File(imgPath)),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 85,
        color: Colors.black,
        child: Row(
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: Colors.white,
              child: Icon(
                Icons.check,
                size: 34,
                color: Colors.black,
              ),
                onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                return OutputScreen(imgPath: imgPath);
              }));

            })
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
