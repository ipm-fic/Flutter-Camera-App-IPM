import 'package:camera_app/src/blocs/colorsBloc.dart';
import 'package:camera_app/src/models/endPointParser.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                  if (data == "404 (not found)") return _onNotFound();
                  if (data == "408 (request timeout)")
                    return _onRequestTimeout();
                  if (data == "500 (internal") return _onInternal();
                  if (data == "SocketEx") return _onSocket();
                  return jsonParser(data, context);
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

  Widget _onNotFound() {
    return AlertDialog(
      title: new Text("Error"),
      content: new Text(
          "No se ha podido establecer conexión con el servidor.\n\n(No encontrado)"),
      actions: <Widget>[
        new FlatButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );
  }

  Widget _onRequestTimeout() {
    return AlertDialog(
      title: new Text("Error"),
      content: new Text(
          "No se ha podido establecer conexión con el servidor.\n\n(Timeout)"),
      actions: <Widget>[
        new FlatButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );
  }

  Widget _onInternal() {
    return AlertDialog(
      title: new Text("Error"),
      content: new Text(
          "No se ha podido establecer conexión con el servidor.\n\n(Interno)"),
      actions: <Widget>[
        new FlatButton(
            child: new Text("OK"),
            onPressed: () {
              Navigator.pop(context);
            })
      ],
    );
  }

  Widget _onSocket() {
    return AlertDialog(
      title: new Text("Error"),
      content: new Text(
          "No se ha podido establecer conexión con el servidor.\n\n(Revise su conexión a internet)"),
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
