import 'package:camera_app/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class ColorsBloc {
  final _repository = Repository();
  final _colorsFetcher = PublishSubject<String>();

  Observable<String> get colors => _colorsFetcher.stream;

  fetchColors(imgPath) async {
    String color = await _repository.colorsProvider.postImage(imgPath);
    _colorsFetcher.sink.add(color);
  }

  dispose() {
    _colorsFetcher.close();
  }
}

final bloc = ColorsBloc();
