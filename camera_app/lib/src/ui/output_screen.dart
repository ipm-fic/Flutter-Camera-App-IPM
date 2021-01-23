import 'package:camera_app/src/blocs/colorsBloc.dart';
import 'package:camera_app/src/models/endPointParser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_device_type/flutter_device_type.dart';

class OutputScreen extends StatefulWidget {
  final String imgPath;

  const OutputScreen({Key key, this.imgPath}) : super(key: key);

  @override
  _OutputScreenState createState() => _OutputScreenState();
}

class _OutputScreenState extends State<OutputScreen> {
  Future<String> futureString;

  @override
  void initState() {
    super.initState();
    bloc.fetchColors(widget.imgPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Análisis de los colores'),
        shadowColor: Colors.white,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: bloc.colors,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                if (snapshot.hasData) {
                  String data = snapshot.data;
                  return exceptionChecker(data, context);
                } else if (snapshot.hasError) {
                  return AlertDialog(
                    title: new Text("Error"),
                    content: new Text(
                        "Se ha detectado un error.\nInténtelo de nuevo más tarde."),
                    actions: <Widget>[
                      new FlatButton(
                          child: new Text("OK"),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget exceptionChecker(String data, BuildContext context) {
    print(data);
    if (!data.startsWith("{")) {
      return _onError(data);
    } else
      return jsonParser(data, context);
  }

  Widget _onError(String error) {
    return AlertDialog(
      title: new Text("Error"),
      content:
          new Text("No se ha podido conectar con el servidor.\n\n($error)"),
      actions: <Widget>[
        new FlatButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );
  }
}
