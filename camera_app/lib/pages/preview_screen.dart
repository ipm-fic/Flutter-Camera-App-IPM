import 'dart:io';
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
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Icon(
                Icons.highlight_off_rounded,
                size: 38,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Icon(
                Icons.check,
                size: 38,
                color: Colors.white,
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
