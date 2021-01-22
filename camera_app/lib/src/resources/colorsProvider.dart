import 'dart:async';

import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:async/async.dart';
import 'package:path/path.dart';

class ColorsProvider {
  String _apiKey =
      'Basic YWNjXzhjMzhiZjZhYWUxMzZlZTo4MGYxOWYwZDQ5YzljYTZmYjYxYWEwMWMwYWYxMjBjOA==';

  Future<String> postImage(String imagePath) async {
    File imageFile = new File(imagePath);

    //ignore: deprecated_member_use
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    Map<String, String> headers = {HttpHeaders.authorizationHeader: _apiKey};
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

    var streamedResponse;

    try {
      streamedResponse =
          await request.send().timeout(Duration(seconds: timeout));

      if (streamedResponse.statusCode == HttpStatus.ok) {
        var responseStream = await streamedResponse.stream.toBytes();
        var responseString = String.fromCharCodes(responseStream);
        return responseString;
      } else if (streamedResponse.statusCode == HttpStatus.notFound) {
        return "No encontrado";
      } else if (streamedResponse.statusCode == HttpStatus.unauthorized) {
        return "Credenciales API no válidas";
      } else if (streamedResponse.statusCode == HttpStatus.badRequest) {
        return "Petición inválida";
      } else if (streamedResponse.statusCode == HttpStatus.forbidden) {
        return "Prohibido";
      } else {
        print("${streamedResponse.statusCode}");
        return "Interno";
      }
    } on TimeoutException catch (_) {
      print(_);
      return "Tiempo de petición excedido";
    } on SocketException catch (error) {
      print(error);
      return "Socket Exception";
    }
  }
}
