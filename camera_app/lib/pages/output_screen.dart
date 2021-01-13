import 'dart:io';
import 'dart:convert';
import 'package:camera_app/pages/preview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';

class OutputScreen extends StatefulWidget {
  final String imgPath;

  const OutputScreen({Key key, this.imgPath}) : super(key: key);

  @override
  _OutputScreenState createState() => _OutputScreenState();
}

Future<String> PostImage(String imagePath) async {
  File imageFile = new File(imagePath);

  //ignore: deprecated_member_use
  var stream =
      new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  var length = await imageFile.length();
  Map<String, String> headers = {
    HttpHeaders.authorizationHeader:
        'Basic YWNjXzhjMzhiZjZhYWUxMzZlZTo4MGYxOWYwZDQ5YzljYTZmYjYxYWEwMWMwYWYxMjBjOA=='
  };
  int timeout = 20;

  var request = new http.MultipartRequest(
      "POST", Uri.parse('https://api.imagga.com/v2/colors'));
  request.headers.addAll(headers);

  var multipartFile = new http.MultipartFile('image', stream, length,
      filename: basename(imageFile.path));

  request.fields['extract_overall_colors '] = "1"; //Default: 1
  request.fields['extract_object_colors '] = "0"; //Default: 1
  request.fields['overall_count'] = "5"; //Default: 5
  request.fields['separated_count'] = "1"; //Default: 3
  request.fields['deterministic'] = "0"; //Default: 0

  request.files.add(multipartFile);

  var streamedResponse =
      await request.send().timeout(Duration(seconds: timeout));

  if (streamedResponse.statusCode == HttpStatus.ok) {
    var responseStream = await streamedResponse.stream.toBytes();
    var responseString = String.fromCharCodes(responseStream);
    // print(responseString);
    return responseString;
  } else {
    throw Exception('Failed HTTP');
  }
}

class _OutputScreenState extends State<OutputScreen> {
  Future<String> futureString;

  @override
  void initState() {
    super.initState();
    futureString = PostImage(widget.imgPath);
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
          ///Image.file(File(widget.imgPath)),
          Expanded(
              child: FutureBuilder(
            future: futureString,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  !snapshot.hasError) {
                String data = snapshot.data;
                return jsonParser(data, context);
              } else if ((snapshot.connectionState != ConnectionState.done)) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return AlertDialog(
                  title: new Text("Error con el servidor"),
                  content: new Text(
                      "No se ha podido realizar la conexión con el servidor, pruebe de nuevo más tarde"),
                  actions: <Widget>[
                    new FlatButton(
                        child: new Text("Galería"),
                        onPressed: () {
                          Navigator.pop(context);
                        })
                  ],
                );
              }
            },
          ))
        ],
      ),
    );
  }

  ListView jsonParser(String snapdata, BuildContext context) {
    Map data = jsonDecode(snapdata);

    var length = data['result']['colors']['image_colors'].length;

    List values;

    List<String> res = [];
    List<Color> colors = [];

    for (var i = 0; i < length; i++) {
      values = data['result']['colors']['image_colors'][i].values.toList();

      res.add(values[1].toString().toUpperCase());
      res.add('HTML Code -> ' + values[6].toString());
      res.add('R: ' +
          values[8].toString() +
          '  G: ' +
          values[5].toString() +
          '  B: ' +
          values[0].toString());
      res.add('Closest color parent: ' + values[3].toString());
      res.add('Percentage in the image: ' + values[7].toStringAsFixed(2) + '%');
      res.add('Closest palette distance: ' + values[4].toString());

      colors.add(Color.fromARGB(255, values[8], values[5], values[0]));
    }

    return ListView.builder(
        shrinkWrap: true,
        itemCount: 6 * length,
        padding: const EdgeInsets.all(20.0),
        itemBuilder: (BuildContext context, int n) => SafeArea(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3.5),
                    child: createView(n, colors, res),
                  ),
                ],
              ),
            ));
  }

  Widget createView(int n, List<Color> colors, List<String> res) {
    if (n % 6 == 0) {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0, bottom: 5),
        child: Column(
          children: <Widget>[
            MaterialButton(
              color: colors[n ~/ 6],
              shape: CircleBorder(),
              onPressed: () {},
            ),
            Text(
              res[n],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
          ],
        ),
      );
    } else {
      return Text(
        res[n],
        style: TextStyle(color: Colors.white),
      );
    }
  }
}
