import 'package:flutter/material.dart';
import 'dart:convert';

ListView jsonParser(String snapdata, BuildContext context) {
  Map data = jsonDecode(snapdata);

  var length = data['result']['colors']['image_colors'].length;

  List values;

  List<String> res = [];
  List<Color> colors = [];

  for (var i = 0; i < length; i++) {
    values = data['result']['colors']['image_colors'][i].values.toList();

    res.add(values[1].toString().toUpperCase());
    res.add('HTML Code: ' + values[6].toString());
    res.add('R: ' +
        values[8].toString() +
        '  G: ' +
        values[5].toString() +
        '  B: ' +
        values[0].toString());
    res.add('Pariente más cercano: ' + values[3].toString());
    res.add('Porcentaje en la imágen: ' + values[7].toStringAsFixed(2) + '%');
    res.add('Paleta más cercana: ' + values[4].toStringAsFixed(2));

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
