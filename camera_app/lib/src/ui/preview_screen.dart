import 'dart:io';
import 'dart:ui';
import 'package:camera_app/src/resources/sizeable.dart';
import 'package:camera_app/src/ui/output_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PreviewScreen extends StatelessWidget {
  final String imgPath;
  final double aspectRatio;

  const PreviewScreen({Key key, this.imgPath, this.aspectRatio})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown,DeviceOrientation.landscapeRight,DeviceOrientation.landscapeLeft]);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(),
      body: Container(
        child: Align(
          alignment: Alignment.center,
          child: SafeArea(
            child: Image.file(File(imgPath)),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: rowHeight(),
        color: Colors.black,
        child: Row(
          children: <Widget>[
            Container(
              height: heightButton(),
              width: widthButton(),
              child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.check,
                    size: buttonSizeGallery(),
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return OutputScreen(imgPath: imgPath);
                    }));
                  }),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
