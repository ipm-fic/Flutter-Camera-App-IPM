import 'package:camera_app/src/blocs/colorsBloc.dart';
import 'package:camera_app/src/models/endPointParser.dart';
import 'package:camera_app/src/resources/sizeable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OutputScreen extends StatefulWidget {
  final String imgPath;

  const OutputScreen({Key key, this.imgPath}) : super(key: key);

  @override
  _OutputScreenState createState() => _OutputScreenState();
}

class _OutputScreenState extends State<OutputScreen> {
  @override
  void initState() {
    super.initState();
    bloc.fetchColors(widget.imgPath);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp,DeviceOrientation.portraitDown,DeviceOrientation.landscapeRight,DeviceOrientation.landscapeLeft]);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(adaptView(80.0, 40.0)),
        child: AppBar(
          centerTitle: true,
          title: Container(child: Text('Análisis de colores', style: TextStyle(fontSize: adaptView(35.0, 20.0)),)),
        ),
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
