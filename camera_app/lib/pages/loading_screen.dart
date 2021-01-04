import 'package:flutter/material.dart';


class LoadingScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
       child: Image.asset('images/hola.png')
       ),
    );
  }


}