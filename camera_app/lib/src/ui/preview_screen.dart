import 'dart:io';
import 'dart:ui';
import 'package:camera_app/src/resources/sizeable.dart';
import 'package:camera_app/src/ui/output_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PreviewScreen extends StatelessWidget {
  final String imgPath;

  const PreviewScreen({Key key, this.imgPath}) : super(key: key);

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
        height: adaptView(150.0, 100.0),
        color: Colors.black,
        child: Row(
          children: <Widget>[
            Container(
              height: adaptView(100.0, 50.0),
              width: adaptView(100.0, 50.0),
              child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.check,
                    size: adaptView(80.0, 30.0),
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
