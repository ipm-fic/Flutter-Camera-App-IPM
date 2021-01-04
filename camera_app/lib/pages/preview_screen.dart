// ignore: avoid_web_libraries_in_flutter
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';



class PreviewScreen extends StatefulWidget{
  final String imgPath;

  const PreviewScreen({Key key, this.imgPath}) : super(key: key);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {


  void initState(){
    super.initState();

  }
  

  @override
  Widget build(BuildContext context){
    var file = new File(widget.imgPath);
    return Scaffold(
      //backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'hola',
        ),
      ),
      body: SafeArea(
        child: Image.file(file),
      ),
    );
  }


}