import 'dart:io';

class GalleryImages {
  File imageFile;
  String imagePath;

  GalleryImages(File file) {
    this.imageFile = file;
    this.imagePath = file.path;
  }

  File getImageFile() {
    return this.imageFile;
  }

  GalleryImages.fromMap(Map map) {
    this.imagePath = map['imagePath'];
  }

  Map toMap() {
    return {
      'imagePath': this.imagePath,
    };
  }
}
