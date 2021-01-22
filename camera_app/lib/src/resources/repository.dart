import 'package:camera_app/src/resources/colorsProvider.dart';

class Repository {
  final colorsProvider = ColorsProvider();

  Future<String> postImage(imagePath) => colorsProvider.postImage(imagePath);
}
