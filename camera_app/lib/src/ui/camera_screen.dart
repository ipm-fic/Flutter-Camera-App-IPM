import 'package:camera/camera.dart';
import 'package:camera_app/src/resources/sizeable.dart';
import 'package:camera_app/src/ui/gallery_screen.dart';
import 'package:camera_app/src/ui/preview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State {
  CameraController controller;
  List cameras;
  int selectedCameraIndex;
  String imgPath;

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;

      if (cameras.length > 0) {
        setState(() {
          selectedCameraIndex = 0;
        });
        _initCameraController(cameras[selectedCameraIndex]).then((void v) {});
      } else {
        print('No camera available');
      }
    }).catchError((err) {
      print('Error :${err.code}Error message : ${err.message}');
    });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high);

    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        print('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }
    if (mounted) {
      setState(() {});
    }
  }

  Widget _rowGalleryButton() {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context, MaterialPageRoute(builder: (context) {
              return MyHomePage(title: 'Galería');
            }));
          },
          child: Icon(
            Icons.photo_library_rounded,
            color: Colors.white,
            size: adaptView(50.0, 30.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: _cameraPreviewWidget(),
              ),
              Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: adaptView(150.0, 100.0),
                    //width: double.infinity,
                    //padding: EdgeInsets.all(15),
                    color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        _cameraToggleRowWidget(),
                        _cameraControlWidget(context),
                        _rowGalleryButton()
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return Center(
        child: const Text(
          'Cargando...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
    );
  }

  Widget _cameraControlWidget(context) {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: adaptView(100.0, 50.0),
          height: adaptView(100.0, 50.0),
          child: FloatingActionButton(
            child: Icon(
              Icons.camera,
              color: Colors.black,
              size: adaptView(50.0, 30.0)
            ),
            backgroundColor: Colors.white,
            onPressed: () {
              _onCapturePressed(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _cameraToggleRowWidget() {
    if (cameras == null || cameras.isEmpty) {
      return Spacer();
    }
    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: FlatButton.icon(
          onPressed: _onSwitchCamera,
          icon: Icon(
            _getCameraLensIcon(lensDirection),
            color: Colors.white,
            size: adaptView(50.0, 26.0),
          ),
          label: Text(
            '${(lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1).toUpperCase() == "BACK") ? "FRONT" : "BACK"}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: adaptView(25.0, 15.0)
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCameraLensIcon(CameraLensDirection direction) {
    switch (direction) {
      case CameraLensDirection.back:
        return CupertinoIcons.switch_camera;
      case CameraLensDirection.front:
        return CupertinoIcons.switch_camera_solid;
      case CameraLensDirection.external:
        return Icons.camera;
      default:
        return Icons.device_unknown;
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error:${e.code}\nError message : ${e.description}';
    print(errorText);
  }

  Future<XFile> takePic() async {
    try {
      XFile file = await controller.takePicture();
      return file;
    } catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  void _onCapturePressed(context) {
    takePic().then((XFile file) {
      if (mounted) {
        setState(() {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PreviewScreen(
                imgPath: file.path,
              ),
            ),
          );
        });
      }
    });
  }

  void _onSwitchCamera() {
    selectedCameraIndex =
        selectedCameraIndex < cameras.length - 1 ? selectedCameraIndex + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIndex];
    _initCameraController(selectedCamera);
  }
}
