import 'dart:convert';
import 'dart:io';
import 'package:camera_app/src/resources/gallery_images.dart';
import 'package:camera_app/src/ui/preview_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'camera_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<GalleryImages> _imagesList = [];
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    initSharedPreferences();
    super.initState();
  }

  initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    readData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              onPressed: () {
                checkPermissionsGallery(context);
              },
              icon: Icon(
                Icons.add_box,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
        centerTitle: true,
        shadowColor: Colors.white24,
      ),
      body: SafeArea(
        child: _stringOrPic(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          checkPermissionsCamera(context);
        },
        tooltip: 'Hacer foto',
        backgroundColor: Colors.white,
        child: Icon(
          CupertinoIcons.right_chevron,
          color: Colors.black,
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _stringOrPic(BuildContext context) {
    if (_imagesList.isEmpty) {
      return Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            "Utiliza el botón (+) para añadir fotos o pulsa el icono con la flecha"
            " para realizar una nueva foto.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, height: 1.8),
          ),
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(20),
        child: _loadGallery(context),
      );
    }
  }

  void _showPhotoLibrary(BuildContext context) async {
    final picker = ImagePicker();

    final file = await picker.getImage(source: ImageSource.gallery);
    if (file == null)
      return;
    else {
      File imageFile = File(file.path);
      setState(() {
        _imagesList.add(new GalleryImages(imageFile));
        saveData();
      });
    }
  }

  void checkPermissionsGallery(BuildContext context) async {
    var galleryStatus = await Permission.storage.status;

    if (!galleryStatus.isGranted & !galleryStatus.isPermanentlyDenied) {
      await Permission.storage.request();
    } else {
      if (galleryStatus.isPermanentlyDenied) {
        setPermissionAlertGallery(context);
      } else {
        _showPhotoLibrary(context);
      }
    }
  }

  void _oncapturePressed(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => CameraScreen()));
  }

  Widget _loadGallery(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onLongPress: () {
            setState(() {
              _imagesList.removeAt(index);
              saveData();
            });
          },
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PreviewScreen(
                          imgPath: _imagesList[index].imagePath,
                        )));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                  image: FileImage(
                    File(_imagesList[index].imagePath),
                  ),
                  fit: BoxFit.cover),
            ),
          ),
        );
      },
      itemCount: _imagesList.length,
    );
  }

  void saveData() {
    List<String> spList =
        _imagesList.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences.setStringList('imageList', spList);
  }

  void readData() {
    List<String> spList = sharedPreferences.getStringList('imageList') ?? [];
    _imagesList =
        spList.map((item) => GalleryImages.fromMap(json.decode(item))).toList();
    setState(() {});
  }

  checkPermissionsCamera(BuildContext context) async {
    var cameraStatus = await Permission.camera.status;
    var microStatus = await Permission.microphone.status;

    if (!cameraStatus.isGranted & !cameraStatus.isPermanentlyDenied) {
      await Permission.camera.request();
    }
    if (!microStatus.isGranted & !microStatus.isPermanentlyDenied) {
      await Permission.microphone.request();
    } else {
      if (cameraStatus.isPermanentlyDenied) {
        setPermissionAlert(context, "cámara");
      }
      if (microStatus.isPermanentlyDenied) {
        setPermissionAlert(context, "micrófono");
      }
      if (cameraStatus.isGranted & microStatus.isGranted) {
        _oncapturePressed(context);
      }
    }
  }

  setPermissionAlert(BuildContext context, String perm) {
    Widget text = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Se requieren permisos"),
      content: Text(
          "Se requiere conceder permisos de acceso a $perm para capturar fotos.\n\n" +
              "Permita el acceso a $perm desde la sección permisos de la aplicación en los ajustes del dispositivo."),
      actions: [
        text,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  setPermissionAlertGallery(BuildContext context) {
    Widget text = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Se requieren permisos"),
      content: Text("Se requiere conceder permisos de acceso a galería.\n\n" +
          "Permita el acceso desde la sección permisos de la aplicación en los ajustes del dispositivo."),
      actions: [
        text,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
