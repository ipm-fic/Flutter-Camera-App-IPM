import 'dart:io';

class GalleryImages {
  File imageFile;
  String imagePath;

  GalleryImages(File file) {
    this.imageFile = file;
  }

  File getImageFile() {
    return this.imageFile;
  }
}
