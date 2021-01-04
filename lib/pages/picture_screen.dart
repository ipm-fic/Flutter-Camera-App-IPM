import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app2/pages/output_screen.dart';

class PictureScreen extends StatelessWidget{
  final String imgPath;

  const PictureScreen({Key key, this.imgPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "¿Desea utilizar esta imagen?"
        ),
      ),
      body: Image.file(File(imgPath)),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
            return OutputScreen(imgPath: imgPath);
          }));
        },
        child: Icon(
          Icons.send,
          color: Colors.black,
        ),
      ),
    );
  }

}